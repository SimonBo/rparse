require 'open-uri'
require 'rubygems/package'

class RepoParser
  def initialize
    @base_url = 'https://cran.r-project.org/src/contrib/'
    @pack_url = 'https://cran.r-project.org/src/contrib/PACKAGES'
    @errors = []
  end
  
  def refresh_repos
    data, errors = get_data
    data.each do |k, v|
      Package.create!(
        description: v[:description],
        title: v[:title],
        authors: v[:authors],
        version: v[:version],
        maintainers: v[:maintainers],
        license: v[:license],
        publication_date: v[:publication_date]
        )
    end
  end
  
  def get_data(links: get_links) 
    data = {}
    errors = {}
    
    links.each do |link|
      begin
        open(@base_url + link) do |remote_file|
          t = Gem::Package::TarReader.new(Zlib::GzipReader.open(remote_file))
          t.rewind
          t.each do |entry|
            if(entry.full_name.include? 'DESCRIPTION')
              info = entry.read

              data[link] = parse_entry(info)
            end
          end
        end
      rescue => e
        puts 'FAILED!'
        puts link
        puts e
        errors[link] = e.to_s
        next
      end
    end
    
    return data, errors
  end

  private

  def parse_entry(info)
    EntryParser.new(entry: info).parse
  end

  def get_links
    agent = Mechanize.new
    
    pack_page = agent.get(@pack_url)
    package_names =  pack_page.body.lines.select { |l| l.split.first == "Package:" }.map { |l| l.split.last }
    
    page = agent.get(@base_url)
    links = page.links_with(:href => /tar.gz/).map(&:href)
    links
  end
end
