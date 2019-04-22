
class RepoParser
  def initialize(params = {})
    @threads = params.fetch :threads, 100
    @package_data = params[:package_data] || PackageDataExtractor.new.data
  end
  
  def refresh_repos
    Parallel.each(@package_data, in_threads: @threads) do |pck_data|
      ActiveRecord::Base.connection_pool.with_connection do
        create_or_update_package(pck_data)
      end
    end
  end
  
  private
  
  def create_or_update_package(pck_data)
    pck = Package.find_or_initialize_by(title: pck_data[:title])
    pck.assign_attributes(
      name: pck_data[:name],
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
  