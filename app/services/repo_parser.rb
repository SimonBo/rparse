require 'open-uri'
require 'rubygems/package'

class RepoParser
  def initialize
    @base_url = 'https://cran.r-project.org/src/contrib/'
    @pack_url = 'https://cran.r-project.org/src/contrib/PACKAGES'
    @errors = []
  end
  
  def refresh_repos
    data.each do |pck_data|
      create_or_update_package(pck_data)
    end
  end
  
  def data(links: get_links) 
    data = []
    errors = {}
    
    links.each do |link|
      begin
        open(@base_url + link) do |remote_file|
          t = Gem::Package::TarReader.new(Zlib::GzipReader.open(remote_file))
          t.rewind
          t.each do |entry|
            if(entry.full_name.include? 'DESCRIPTION')
              info = entry.read

              data << parse_entry(info)
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
    
    return data
  end

  def get_links
    agent = Mechanize.new
    
    pack_page = agent.get(@pack_url)
    package_names =  pack_page.body.lines.select { |l| l.split.first == "Package:" }.map { |l| l.split.last }
    
    page = agent.get(@base_url)
    links = page.links_with(:href => /tar.gz/).map(&:href)
    links
  end

  private

  def parse_entry(info)
    EntryParser.new(entry: info).parse
  end

  def create_or_update_package(pck_data)
    pck = Package.find_or_initialize_by(title: pck_data[:title])
    pck.assign_attributes(
      description: pck_data[:description],
      title: pck_data[:title],
      authors: pck_data[:authors],
      version: pck_data[:version],
      maintainers: pck_data[:maintainers],
      license: pck_data[:license],
      publication_date: pck_data[:publication_date]
    )
    pck.save!
  end
end
