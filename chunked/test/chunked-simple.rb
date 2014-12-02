
require_relative '../lib/chunked/simple'

pump = Chunked::Simple.new(4) {|str| puts "> " + str.inspect }

strings = [
	'S',
	'GV',
	'sbG',
	'8gd2',
	'9ybGQ',
	'hCg',
]

strings.each do |s|
	puts "Push #{s.inspect}"
	pump << s
end
puts "Finalize"
pump.finalize
puts "Done", "----"

