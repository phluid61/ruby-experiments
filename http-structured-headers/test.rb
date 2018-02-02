require_relative 'http-structured-headers'

# successes:
[
  ['123'],
  ['-23'],
  ['123.45'],
  ['-23.45'],
  ['""'],
  ['"foobar"'],
  ['"foo\\\\bar"'],
  ['"foo\\"bar"'],
  ['*cGhsdWlkNjE*'],
  ['phluid61'],
  ['a=a,b=123, c=-3.14 ,d=*YQ* , e="z"', :dictionary],
  ['a,123, -3.14 ,*YQ* , "z"', :list],
  ['a,a,a,a', :list],
  ['text/plain; charset=utf-8; test', :label],
].each do |args|
  puts '-'*5
  p args
  p HTTPStructuredHeaders.parse(*args)
end

puts '='*5

# errors:
[
  ['text/plain; test=', :dictionary],
  ['00000000000000000001'],
  ['"unterminated string'],
  ['*unterminated binary'],
  ['*cGhsdWlkNjE=*'],
  ['---'],
  ['0-1'],
  ['0..1'],
  ['"bad\\nescape"'],
  ['a=a, a=a', :dictionary],
].each do |args|
  p args
  begin
    p HTTPStructuredHeaders.parse(*args)
  rescue => e
    puts e
  end
  puts '-'*5
end
