require 'open-uri'
require 'rubygems/package'

class RepoParser
  def initialize
    @errors = []
  end
  
  def refresh_repos
    data.each do |d|
      Package.create!(
        description: d.description,
        title: d.title,
        authors: d.authors,
        version: d.version,
        maintainers: d.maintainers,
        license: d.license,
        publication_date: d.publication_date
        )
    end
  end
  
  def data 
    base_url = 'https://cran.r-project.org/src/contrib/'
    pack_url = 'https://cran.r-project.org/src/contrib/PACKAGES'
    
    agent = Mechanize.new
    
    pack_page = agent.get(pack_url)
    package_names =  pack_page.body.lines.select { |l| l.split.first == "Package:" }.map { |l| l.split.last }
    
    page = agent.get(base_url)
    links = page.links_with(:href => /tar.gz/).map(&:href)
    
    data = {}
    errors = {}
    
    links.each do |link|
      begin
        open(base_url + link) do |remote_file|
          t = Gem::Package::TarReader.new(Zlib::GzipReader.open(remote_file))
          t.rewind
          t.each do |entry|
            if(entry.full_name.include? 'DESCRIPTION')
              data[link] = entry.read
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
end