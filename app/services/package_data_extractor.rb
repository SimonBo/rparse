require 'open-uri'
require 'rubygems/package'

#enforce returning TempFile from opening urls
OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
OpenURI::Buffer.const_set 'StringMax', 0


class PackageDataExtractor
  attr_reader :links
  
  def initialize(params = {})
    @base_url = params.fetch :base_url, 'https://cran.r-project.org/src/contrib/'
    @pack_url = params.fetch :pack_url, 'https://cran.r-project.org/src/contrib/PACKAGES'
    @links = params.fetch :links, fetch_links
    @package_names = params.fetch :package_names, fetch_package_names
    @entry_parser = params.fetch :entry_parser, EntryParser.new
    @result = []
  end
  
  def data 
    @links.each do |link|
      begin
        open(@base_url + link) do |remote_file|
          parse_entry(remote_file)
        end
      rescue => e
        puts 'FAILED!'
        puts link
        puts e
        puts e.backtrace
        next
      end
    end
    
    return @result
  end
  
  def fetch_links
    agent = Mechanize.new
    page = agent.get(@base_url)
    page.links_with(:href => /tar.gz/).map(&:href)
  end
  
  def fetch_package_names
    agent = Mechanize.new
    pack_page = agent.get(@pack_url)
    pack_page.body.lines.select { |l| l.split.first == "Package:" }.map { |l| l.split.last }
  end
  
  private 
  
  def parse_entry(remote_file)
    t = Gem::Package::TarReader.new(Zlib::GzipReader.open(remote_file))
    t.rewind
    t.each do |entry|
      if(entry.full_name.include? 'DESCRIPTION')
        info = entry.read
        parsed_entry = @entry_parser.parse(info)
        
        if @package_names.include? parsed_entry[:name]
          @result << parsed_entry 
        end
      end
    end
  end
end