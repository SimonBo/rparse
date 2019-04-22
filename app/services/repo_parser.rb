# frozen_string_literal: true

class RepoParser
  def initialize(params = {})
    @threads = params.fetch :threads, 10
    @in_batches_of = params.fetch :in_batches_of, 10
    @links_array = params[:links_array] || LinkFetcher.new.fetch.each_slice(@in_batches_of).to_a
  end
  
  def refresh_repos    
    Parallel.each(@links_array, in_threads: @threads) do |links|
      handle_links(links)
    end
  end
  
  private
  
  def handle_links(links)
    data(links).each do |pck_data|
      ActiveRecord::Base.connection_pool.with_connection do
        begin 
          create_or_update_package(pck_data)
        rescue => e 
          puts 'FAILED'
          puts e
          puts pck_data
          next
        end
      end
    end
  end
  
  def data(links)
    PackageDataExtractor.new(links: links).data
  end
  
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
  