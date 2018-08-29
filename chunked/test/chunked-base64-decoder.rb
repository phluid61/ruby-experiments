
require_relative '../lib/chunked/base64-decoder'

dec  = ''
pump = Chunked::Base64Decoder.new {|str| puts "> " + str.inspect; dec << str }

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

puts dec, "---", Base64.encode64(dec), "---"

