require 'benchmark'

Benchmark.bm do |benchmark|
  links = PackageDataExtractor.new.links.first(30)
  data = PackageDataExtractor.new(links: links).data
  run_n = 100
  
  [1, 10, 30, 100, 200].each do |n|
    benchmark.report("threads #{n}") do
      run_n.times do 
        Package.delete_all
        RepoParser.new(threads: n, package_data: data).refresh_repos
      end
    end
  end
end

# RESULT
# [#<Benchmark::Tms:0x007fcf04a45d50 @label="threads 1", @real=19.768992000000253, @cstime=0.0, @cutime=0.0, @stime=3.2300000000000004, @utime=4.7499999999999964, @total=7.979999999999997>, #<Benchmark::Tms:0x007fffbea9b6e8 @label="threads 10", @real=11.419063999999707, @cstime=0.0, @cutime=0.0, @stime=5.209999999999997, @utime=5.550000000000004, @total=10.760000000000002>, #<Benchmark::Tms:0x007fffbcfb5748 @label="threads 30", @real=11.92114599999968, @cstime=0.0, @cutime=0.0, @stime=5.419999999999998, @utime=6.0, @total=11.419999999999998>, #<Benchmark::Tms:0x007fcf04a9e338 @label="threads 100", @real=11.098245000000134, @cstime=0.0, @cutime=0.0, @stime=5.25, @utime=5.419999999999995, @total=10.669999999999995>, #<Benchmark::Tms:0x007fcf051fd480 @label="threads 200", @real=11.277464000000691, @cstime=0.0, @cutime=0.0, @stime=5.530000000000001, @utime=5.160000000000004, @total=10.690000000000005>]