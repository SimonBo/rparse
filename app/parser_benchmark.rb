require 'benchmark'

Benchmark.bm do |benchmark|
  rp = RepoParser.new 
  data = rp.data(links: rp.get_links.first(50))
  run_n = 10
  
  benchmark.report("Normal") do
    run_n.times do 
      Package.delete_all
      data.each do |pck_data|
        rp.send :create_or_update_package, pck_data
      end
    end
  end
  
  [10, 30, 100, 200].each do |n|
    benchmark.report("threads #{n}") do
      run_n.times do 
        Package.delete_all
        Parallel.each(data, in_threads: n) do |pck_data|
          ActiveRecord::Base.connection_pool.with_connection do
            rp.send :create_or_update_package, pck_data
          end
        end
      end
    end
  end
end

# RESULT
# [#<Benchmark::Tms:0x007fcf050c7908 @label="Normal", @real=3.0839540000000056, @cstime=0.0, @cutime=0.0, @stime=0.46999999999999975, @utime=0.8800000000000003, @total=1.35>, #<Benchmark::Tms:0x007fcf04a743d0 @label="threads 10", @real=1.8333909999999918, @cstime=0.0, @cutime=0.0, @stime=0.8300000000000001, @utime=0.7599999999999998, @total=1.5899999999999999>, #<Benchmark::Tms:0x007fcf04962438 @label="threads 30", @real=1.8586770000000001, @cstime=0.0, @cutime=0.0, @stime=0.6700000000000004, @utime=1.0500000000000003, @total=1.7200000000000006>, #<Benchmark::Tms:0x007fcf1015ecf8 @label="threads 100", @real=1.735748000000001, @cstime=0.0, @cutime=0.0, @stime=0.7199999999999998, @utime=0.8899999999999997, @total=1.6099999999999994>, #<Benchmark::Tms:0x007fcf04b68ae8 @label="threads 200", @real=1.8128889999999984, @cstime=0.0, @cutime=0.0, @stime=0.6100000000000003, @utime=0.9500000000000002, @total=1.5600000000000005>]