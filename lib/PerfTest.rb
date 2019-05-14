class PerfTest
  def initialize(task_count, batch_size)
    puts "init"
    @events_queue = []
    @task_count = task_count
    @batch_size = batch_size
    @num_threads_submitted = 0
    @pool = Concurrent::CachedThreadPool.new
    $count = Concurrent::AtomicFixnum.new
    @start_time = Time.now
  end

  def start
    # First 3 secs
    add_to_events_queue(@task_count/2)
    sleep 1
    consume_all_events() if @events_queue.size > 0
    sleep 1
    consume_all_events() if @events_queue.size > 0
    sleep 1
    consume_all_events() if @events_queue.size > 0

    # 4th second
    add_to_events_queue(@task_count/4)
    sleep 1
    consume_all_events() if @events_queue.size > 0

    # 5th seconds onward
    add_to_events_queue(@task_count/4)
    while $count.value != @task_count
      sleep 1
      consume_all_events() if @events_queue.size > 0
    end
  end

  def add_to_events_queue(count)
    puts "add_to_events_queue"
    for idx in 1..count
      @events_queue << Task.new(idx)
    end
  end

  def consume_all_events
    puts "consume_all_events | There are #{@events_queue.size} events."
    num_events_to_process = @events_queue.size.dup
    while num_events_to_process > 0
      events_submitted = consume_events(num_events_to_process)
      num_events_to_process = num_events_to_process - events_submitted
    end
  end

  def consume_events(num_events_to_process)
    selected_size = (num_events_to_process > @batch_size) ? @batch_size : num_events_to_process
    selected_events = @events_queue.slice!(0, selected_size)
    submit_to_thread_pool(selected_events)

    @num_threads_submitted = @num_threads_submitted + selected_size
    puts "Submitted #{@num_threads_submitted} Threads."

    selected_size
  end

  def submit_to_thread_pool(events)
    @pool.post do
      process_events(events)
    end
  end

  def process_events(events)
    events.each do |event|
      event.process
    end
    puts "$count = #{$count.value}"
    puts "Processed #{@task_count} events | Time taken: #{Time.now - @start_time}" if ($count.value == @task_count)
  end
end

class Task
  def initialize(id)
    @id = id
  end

  def process
    sleep(1)
    $count.increment
  end
end