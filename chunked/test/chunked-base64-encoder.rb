
require_relative '../lib/chunked/base64-encoder'

enc  = ''
pump = Chunked::Base64Encoder.new {|b64| puts "> " + b64.inspect; enc << b64 }

strings = [
	'1',
	'22',
	'333',
	'4444',
	'55555',
	'666666',
	'7777777',
]

strings.each do |s|
	puts "Push #{s.inspect}"
	pump << s
end
puts "Finalize"
pump.finalize
puts "Done", "----"

puts enc, "---", Base64.decode64(enc), "---"

