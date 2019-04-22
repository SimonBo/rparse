require 'benchmark'

Benchmark.bm do |benchmark|
  links = PackageDataExtractor.new.links.first(30)
  data = PackageDataExtractor.new(links: links).data
  run_n = 10

  [1, 4, 10, 100].each do |n|
    benchmark.report("threads #{n}") do
      run_n.times do
        Package.delete_all
        RepoParser.new(threads: n, package_data: data).refresh_repos
      end
    end
  end
end

# RESULT
# @label="threads 1", @real=0.9997770000009041
# @label="threads 4", @real=0.72076399999969
# @label="threads 10", @real=0.567892999999458
# @label="threads 100", @real=0.54185200000029


Benchmark.bm do |benchmark|
  links = PackageDataExtractor.new.links.first(30)
  run_n = 10

  [1, 4, 10, 100].each do |n|
    benchmark.report("threads #{n}") do
      run_n.times do
        PackageDataExtractor.new(threads: n, links: links).data
      end
    end
  end
end


# user     system      total        real
# threads 1  6.700000   3.200000   9.900000 ( 64.673512)
# threads 4  7.050000   3.360000  10.410000 ( 24.646223)
# threads 10  6.950000   4.110000  11.060000 ( 21.778536)
# threads 100  6.810000   3.890000  10.700000 ( 28.813455)