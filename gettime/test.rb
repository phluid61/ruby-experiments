require_relative 'lib/gettime'

Process.clocks.each_pair do |name,id|
	puts "#{name}: #{Process.clock_gettime(id)} @ #{Process.clock_getres(id)}"
end
