require 'concurrent'
require 'concurrent/atomic/atomic_fixnum'

class ConcurrentRubyThreadTest

  def initialize(req_amt)
    @count = Concurrent::AtomicFixnum.new
    @req_amt = req_amt
    @start_time
    #@pool = Concurrent::CachedThreadPool.new
    @pool = Concurrent::FixedThreadPool.new(100)
  end

  def start()
    puts "ConcurrentRuby | Start"
    @start_time = Time.now
    for idx in 1..@req_amt do
      submitTask(idx)
    end
    puts "ConcurrentRuby | Task submitted"
  end

  def submitTask(idx)
    @pool.post do

      puts "Thread name: #{Thread.current.to_s}"
      sleep(1)
      puts "ConcurrentRuby | Done (#{@req_amt} threads completed) | Time taken = #{Time.now - @start_time} seconds." if (@count.increment == @req_amt)
    end
  end

  # def close()
  #   @pool.wait_for_termination
  #   puts "ConcurrentRuby | close"
  # end
end