Chunked
=======

Pumps for handling chunked data.

For example: when receiving a Base64-encoded string in chunks, use `Chunked::Base64Decoder`:

```ruby
$decoded_string = ''
decoder = Chunked::Base64Decoder.new do |decoded_chunk|
  $decoded_string << decoded_chunk
end

fh = open(some_location, 'r')
while (chunk = fh.read(4096))
  decoder.push chunk
end
decoder.finalize

puts $decoded_string

```
