#!ruby

$X = 799
$Y = 799

require 'optparse'
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] [<x>,<y>]"

  opts.on('-wN', '--width=N', OptionParser::DecimalInteger, 'screen width (default=100)') do |val|
    raise "width must be a positive integer (#{val})" if val < 1
    $X = val - 1
  end

  opts.on('-hN', '--height=N', OptionParser::DecimalInteger, 'screen height (default=40)') do |val|
    raise "height must be a positive integer (#{val})" if val < 1
    $Y = val - 1
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

$bitmap = ($Y + 1).times.map { ($X + 1).times.map { [255,255,255] } }

def set x, y, r, b, g
  $bitmap[y][x] = [r, g, b]
  nil
end

# -- draw origin

set 0,0, 0,0,255

# -- draw end

set $X,$Y, 0,255,0

# -- draw anchor, if on-screen

if $A >= 0 && $A <= $X && $B >= 0 && $B <= $Y
  set $A,$B, 255,127,0
end

# -- draw path

def tween a, z, progress
  distance = z - a
  travelled = distance * progress
  a + travelled
end

def project x0,y0, x1,y1, stepN
  # FIXME: SQRT(2)
  how_far_along = Rational(stepN, $steps - 1)

  [
    tween(x0, x1, how_far_along).to_i,
    tween(y0, y1, how_far_along).to_i,
  ]
end

($steps - 2).times do |_step|
  step = _step + 1

  x1, y1 = project 0,0, $A,$B, step
  x2, y2 = project x1,y1, $X,$Y, step

  # -- draw real point

  how_far_along = Rational(step, $steps - 1)
  g = tween(0, 255, how_far_along).to_i

  set x2,y2, 0,g,255-g
end

# == END OF PROGRAM

$stdout.write $bitmap.flatten.pack('C*')
