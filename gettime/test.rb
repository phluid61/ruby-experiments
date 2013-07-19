require_relative 'lib/gettime'

Process.clocks.each do |clock|
	puts "#{clock}: #{Process.clock_gettime(clock)} @ #{Process.clock_getres(clock)}"
end

