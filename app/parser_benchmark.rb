require 'benchmark'

links = [LinkFetcher.new.fetch.first(10)]
run_n = 5

Benchmark.bm do |benchmark|
  [0, 4, 10, 100].each do |n|
    benchmark.report("threads #{n}") do
      run_n.times do
        Package.delete_all
        RepoParser.new(threads: n, links_array: links).refresh_repos
      end
    end
  end
end

# RESULT
# @label="threads 0", @real=22.98542699999996
# @label="threads 4", @real=7.983371000000034
# @label="threads 10", @real=14.031394999999975
# @label="threads 100", @real=7.538833999999952


Benchmark.bm do |benchmark|
  [0, 4, 10, 100].each do |n|
    benchmark.report("threads #{n}") do
      run_n.times do
        PackageDataExtractor.new(threads: n, links: links.first).data
      end
    end
  end
end


# user     system      total        real
# threads 0  1.370000   1.030000   2.400000 ( 16.583967)
# threads 4  1.560000   1.390000   2.950000 (  7.528409)
# threads 10  1.240000   1.610000   2.850000 (  7.926870)
# threads 100  1.590000   1.280000   2.870000 (  6.822464)

