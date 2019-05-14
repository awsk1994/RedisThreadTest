require './lib/JavaThreadTest'
require './lib/ConcurrentRubyThreadTest'

puts "> Program Start"

javaTest = JavaThreadTest.new(1000)
javaTest.start
#javaTest.close

rubyTest = ConcurrentRubyThreadTest.new(1000)
rubyTest.start
#rubyTest.close

sleep(50)