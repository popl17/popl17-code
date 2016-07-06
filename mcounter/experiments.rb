require 'active_record'
require 'transaction_retry'
require 'benchmark'
require_relative 'app/models/m_counter'
require_relative 'my_real_transaction'

my_logger = Logger.new('log/experiments.log')
my_logger.level= Logger::DEBUG
ActiveRecord::Base.logger = my_logger
configuration = YAML::load(IO.read('config/database.yml'))

ActiveRecord::Base.establish_connection(configuration['development'])
ActiveRecord::Base.connection.execute("TRUNCATE TABLE m_counters")
TransactionRetry.apply_activerecord_patch
TransactionRetry.max_retries=10


mctr = MCounter.new(count: 0)
mctr.save
puts "Count is #{mctr.count}"
# mctr.inc
# puts "Count is #{mctr.count}"
class RdWr
  attr_accessor :mctr
  def initialize mctr
    @mctr = mctr
  end
  def reader
    cnt = 0
    prev_count = 0
    vio_count = 0
    time = 0
    i = 0
    Signal.trap("HUP") { puts "Reader exiting after #{i} reads and #{vio_count} violations"; exit }
    loop do
      i+=1
      time+= Benchmark.realtime {
        ActiveRecord::Base.transaction do
          mctr.reload
          cnt = mctr.count
          if cnt < prev_count then
            vio_count = vio_count+1
            #puts "Monotonicity violated! #{cnt}<#{prev_count}"
          end
          prev_count = cnt
        end
      }
      if i%10000 == 0 then
        puts "The count is #{prev_count}."
      end
    end
  end

  def writer
    1.times do
      mctr.inc
    end
  end
end

rdwr = RdWr.new(mctr)

time = Benchmark.realtime do
  read_pid = Process.fork do
    #$level = :read_committed
    rdwr.reader
  end
  10.times do |i|
    time = Benchmark.realtime {
      pids = (1..96).map do |i|
        Process.fork do
          #$level = :serializable
          rdwr.writer
        end
      end
      pids.each {|pid| Process.waitpid(pid)}
    }
    puts "Write latency(#{i}): #{time}"
  end
  puts "All writers done"
  Process.kill("HUP", read_pid)
end
puts "Total time elapsed: #{time}"
Process.waitall
mctr.reload
puts "Final count is #{mctr.count}"
