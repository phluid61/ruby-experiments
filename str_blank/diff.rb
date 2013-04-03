# encoding: UTF-8
require './blank'

rb = ''
ch = ''
for i in 1..0x10FFFF
	begin
		rb = %q{"\u{%X}"} % i
		ch = eval rb
	
		a = ch.blank?
		b = ch.rb_blank?
		b = !!b
		if a != b
			puts "#{rb} : blank?==#{a.inspect} , rb_blank?==#{b.inspect}"
		end
	rescue ArgumentError => ex
		STDERR.puts "#{rb} is invalid"
	end
end
puts "Done."

