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
# [#<Benchmark::Tms:0x007fffc120ad50 @label="threads 1", @real=0.9997770000009041, @cstime=0.0, @cutime=0.0, @stime=0.23000000000000398, @utime=0.1599999999999966, @total=0.39000000000000057>, #<Benchmark::Tms:0x007fcf04a45710 @label="threads 4", @real=0.72076399999969, @cstime=0.0, @cutime=0.0, @stime=0.22999999999998977, @utime=0.3199999999999932, @total=0.549999999999983>, #<Benchmark::Tms:0x007fce7729d018 @label="threads 10", @real=0.567892999999458, @cstime=0.0, @cutime=0.0, @stime=0.27000000000001023, @utime=0.2400000000000091, @total=0.5100000000000193>, #<Benchmark::Tms:0x007fffc14127d8 @label="threads 100", @real=0.54185200000029, @cstime=0.0, @cutime=0.0, @stime=0.1599999999999966, @utime=0.25, @total=0.4099999999999966>]


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