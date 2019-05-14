require './lib/JavaThreadTest'
require './lib/ConcurrentRubyThreadTest'
require './lib/PerfTest'

puts "> Program Start"

# javaTest = JavaThreadTest.new(1000)
# javaTest.start
# #javaTest.close

# rubyTest = ConcurrentRubyThreadTest.new(1000)
# rubyTest.start
# #rubyTest.close

# sleep(50)

PerfTest.new(500, 100).start

sleep(200)