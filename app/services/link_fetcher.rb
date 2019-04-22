class LinkFetcher
  def initialize(params = {})
    @base_url = params.fetch :base_url, 'https://cran.r-project.org/src/contrib/'
  end
  
  def fetch 
    agent = Mechanize.new
    page = agent.get(@base_url)
    page.links_with(href: /tar.gz/).map(&:href)
  end
end