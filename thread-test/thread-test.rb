require 'threadpuddle'
puddle = ThreadPuddle.new 10
@array = (1..100).to_a

while @array.size > 0
  # this shift is not synced because '@array'
  # is only accessed from the one thread
  item = @array.shift
  #print "popped item #{item.inspect} at time #{Time.now.strftime '%H:%M:%S.%6N'}   Puddle size is #{puddle.size}\n"
  puddle.spawn(item) do |i|
    # simulate some long-running, not entirely
    # uniformly timed operation
    sleep(rand/2+0.01)
    p i
  end
end
puddle.join
