require_relative 'objecty'

# successes:
[
  [:parse_item, '123',           123],
  [:parse_item, '-23',           -23],
  [:parse_item, '123.45',        123.45],
  [:parse_item, '-23.45',        -23.45],
  [:parse_item, '""',            ''],
  [:parse_item, '"foobar"',      'foobar'],
  [:parse_item, '"foo\\\\bar"',  'foo\\bar'],
  [:parse_item, '"foo\\"bar"',   'foo"bar'],
  [:parse_item, '*cGhsdWlkNjE*', 'phluid61'],
  [:parse_item, 'phluid61',      'phluid61'],
  [:parse_dictionary, 'a=a,b=123, c=-3.14 ,d=*YQ* , e="z"', {'a'=>'a', 'b'=>123, 'c'=>-3.14, 'd'=>'a', 'e'=>'z'}],
  [:parse_list, 'a,123, -3.14 ,*YQ* , "z"',                 ['a', 123, -3.14, 'a', 'z']],
  [:parse_list, 'a,a,a,a',                                  ['a','a','a','a']],
  [:parse_plabel, 'text/plain; charset=utf-8; test',        ['text/plain', {'charset'=>'utf-8', 'test'=>nil}]],

  [:parse_list, 'a, 123, b;c=d;e, f', ['a', 123, ['b', {'c'=>'d','e'=>nil}], 'f']],
].each do |args|
  puts '-'*5
  method, string, exp = args
  parser = Parser.new(string)
  puts "Header: #{string}"

  print '=> '
  print (actual = parser.parse_autodetect).inspect
  if actual == exp
    puts "  :)"
  else
    puts "  :(  #{exp.inspect}"
  end

  print '=> '
  print (actual = parser.__send__(method)).inspect
  if actual == exp
    puts "  :)"
  else
    puts "  :(  #{exp.inspect}"
  end
end

puts '='*5

# errors:
[
  # syntax
  [:parse_dictionary, 'text/plain; test='],
  [:parse_dictionary, ''],
  [:parse_list, ''],
  [:parse_item, '00000000000000000001'],
  [:parse_item, '"unterminated string'],
  [:parse_item, '*unterminated binary'],
  [:parse_item, '*cGhsdWlkNjE=*'],
  [:parse_item, '---'],
  [:parse_item, '0-1'],
  [:parse_item, '0..1'],
  [:parse_item, '"bad\\nescape"'],
  # semantics
  [:parse_item,  '9223372036854775809'],
  [:parse_item, '-9223372036854775809'],
  [:parse_dictionary, 'a=a, a=a'],
].each do |args|
  method, string = args
  parser = Parser.new(string)
  puts "Header: #{string}"

  print '=> '
  begin
    p parser.parse_autodetect
  rescue => e
    puts e
  end

  print '=> '
  begin
    p parser.__send__(method)
  rescue => e
    puts e
  end
  puts '-'*5
end

