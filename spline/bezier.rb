#!ruby

$X = 639
$Y = 479

require 'optparse'
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] [<x>,<y>]"

  opts.on('-wN', '--width=N', OptionParser::DecimalInteger, 'screen width (default=640)') do |val|
    raise "width must be a positive integer (#{val})" if val < 1
    $X = val - 1
  end

  opts.on('-hN', '--height=N', OptionParser::DecimalInteger, 'screen height (default=480)') do |val|
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
  $B = rand($Y / 2 - 2) + 1
elsif ARGV.length == 1 && (m = /\A([+-]?\d+),([+-]?\d+)\z/.match(ARGV[0]))
  $A = Integer(m[1], 10)
  $B = Integer(m[2], 10)
else
  puts parser
  exit
end

# == START OF PROGRAM

# ORIGIN:  0,$Y
# ANCHOR: $A,$B
# END:    $X,$Y

$steps = [$X,$Y,$A,$B].max if $steps.nil?


# -- clear screen

$bitmap = ($Y + 1).times.map { ($X + 1).times.map { [255,255,255] } }

def set x, y, r, b, g
  return if y < 0 || y > $bitmap.length || x < 0 || x > $bitmap[y].length
  $bitmap[y][x] = [r, g, b]
  nil
end

# -- draw path

def tween a, z, progress
  distance = z - a
  travelled = distance * progress
  a + travelled
end

def reduce vals, how_far_along
  return vals[0] if vals.length == 1
  prev = nil
  list = []
  vals.each do |val|
    if prev.nil?
      prev = val
      next
    end
    list << tween(prev, val, how_far_along)
    prev = val
  end
  reduce list, how_far_along
end

($steps - 2).times do |_step|
  step = _step + 1

  how_far_along = Rational(step, $steps - 1)

  x = reduce([0, $A, $X], how_far_along).to_i
  y = reduce([$Y,$B, $Y], how_far_along).to_i

  # -- draw real point

  g = tween(0, 255, how_far_along).to_i

  set x,y, 0,g,255-g
end

# -- draw origin

set 0,$Y  , 0,0,255
set 1,$Y  , 0,0,255
set 1,$Y-1, 0,0,255
set 0,$Y-1, 0,0,255

# -- draw end

set $X  ,$Y  , 0,255,0
set $X-1,$Y  , 0,255,0
set $X-1,$Y-1, 0,255,0
set $X  ,$Y-1, 0,255,0

# -- draw anchor, if on-screen

set $A,$B, 255,127,0
set $A-1,$B-1, 255,127,0
set $A+1,$B-1, 255,127,0
set $A+1,$B+1, 255,127,0
set $A-1,$B+1, 255,127,0

set $A-2,$B-2, 255,127,0
set $A+2,$B-2, 255,127,0
set $A+2,$B+2, 255,127,0
set $A-2,$B+2, 255,127,0

# == END OF PROGRAM

$stdout.write $bitmap.flatten.pack('C*')
