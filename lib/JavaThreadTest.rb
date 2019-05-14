require 'java'
java_import java.util.concurrent.Executors

class JavaThreadTest

  def initialize(req_amt)
    @count = java.util.concurrent.atomic.AtomicInteger.new
    @req_amt = req_amt
    @start_count
    #@executor = Executors.newCachedThreadPool()
    @executor = Executors.newFixedThreadPool(100)
  end

  def start
    puts "Java | Start"
    @start_time = Time.now
    for idx in 1..@req_amt
      submitTask(idx)
    end
    puts "Java | Task submitted"
  end

  def submitTask(idx)
    @executor.submit do
      java.lang.Thread.sleep(1000)
      puts "Java | Done (#{@req_amt} threads completed) | Time taken = #{Time.now - @start_time} seconds." if (@count.incrementAndGet == @req_amt)
    end
  end

  # def close
  #   @executor.shutdown
  #   puts "Java | close"
  # end
end