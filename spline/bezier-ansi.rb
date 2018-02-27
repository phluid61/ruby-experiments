#!ruby

$X = 120
$Y = 60

require 'optparse'
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] [<x>,<y>]"

  opts.on('-wN', '--width=N', OptionParser::DecimalInteger, 'screen width (default=100)') do |val|
    raise "width must be a positive integer (#{val})" if val < 1
    $X = val
  end

  opts.on('-hN', '--height=N', OptionParser::DecimalInteger, 'screen height (default=40)') do |val|
    raise "height must be a positive integer (#{val})" if val < 1
    $Y = val
  end

  opts.on('-sN', '--steps=N', OptionParser::DecimalInteger, 'number of steps') do |val|
    raise "steps must be a positive integer (#{val})" if val < 1
    $steps = val
  end
end

parser.parse!

if ARGV.length == 0
  $A = rand($X - 2) + 1
  $B = rand($Y - 2) + 1
elsif ARGV.length == 1 && (m = /\A([+-]?\d+),([+-]?\d+)\z/.match(ARGV[0]))
  $A = Integer(m[1], 10)
  $B = Integer(m[2], 10)
else
  puts parser
  exit
end

# == START OF PROGRAM

# ORIGIN: 0,0
# ANCHOR: $A,$B
# END:    $X,$Y

$steps = [$X,$Y,$A,$B].max if $steps.nil?

# -- clear screen

print "\e[H\e[J"

# -- draw path

def project x0,y0, x1,y1, stepN
  # FIXME: SQRT(2)
  how_far_along = Rational(stepN, $steps - 1)

  x_distance = x1 - x0
  x_travelled = (x_distance * how_far_along).to_i

  y_distance = y1 - y0
  y_travelled = (y_distance * how_far_along).to_i

  [x0 + x_travelled, y0 + y_travelled]
end

($steps - 2).times do |_step|
  step = _step + 1

  x1, y1 = project 0,0, $A,$B, step
  x2, y2 = project x1,y1, $X,$Y, step

  # -- draw real point

  print "\e[#{y2+1};#{x2+1}H"
  print "+"
end

# -- draw origin

print "\e[0;0H"
print "\e[1;32m@\e[0m"

# -- draw end

print "\e[#{$Y+1};#{$X+1}H"
print "\e[1;34m@\e[0m"

# -- draw anchor, if on-screen

if $A >= 0 && $A <= $X && $B >= 0 && $B <= $Y
  print "\e[#{$B+1};#{$A+1}H"
  print "\e[1;31mX\e[0m"
end

# == END OF PROGRAM

print "\e[#{$Y+2};0H"

