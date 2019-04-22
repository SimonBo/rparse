class PackageNameFetcher
  def initialize(params = {})
    @pack_url = params.fetch :pack_url, 'https://cran.r-project.org/src/contrib/PACKAGES'
  end
  
  def fetch 
    agent = Mechanize.new
    pack_page = agent.get(@pack_url)
    pack_page.body.lines.select { |l| l.split.first == 'Package:' }.map { |l| l.split.last }
  end
end