#!ruby

$X = 639
$Y = 479

require 'optparse'
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] [<x>,<y>] [<u>,<v>]"

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

$A =      rand($X / 3 - 2) + 1
$B =      rand($Y / 2 - 2) + 1

$U = $X - rand($X / 3 - 2) + 1
$V =      rand($Y / 2 - 2) + 1

begin
  unless ARGV.empty?
    if (m = /\A([+-]?\d+),([+-]?\d+)\z/.match(ARGV.shift))
      $A = Integer(m[1], 10)
      $B = Integer(m[2], 10)
    else
      throw RuntimeError
    end
  end

  unless ARGV.empty?
    if (m = /\A([+-]?\d+),([+-]?\d+)\z/.match(ARGV.shift))
      $U = Integer(m[1], 10)
      $V = Integer(m[2], 10)
    else
      throw RuntimeError
    end
  end

  throw RuntimeError unless ARGV.empty?
rescue => e
  puts parser
  exit
end

# == START OF PROGRAM

# ORIGIN:  0,$Y
# ANCHOR1:$A,$B
# ANCHOR2:$U,$V
# END:    $X,$Y

$steps = [$X,$Y,$A,$B,$U,$V].max if $steps.nil?


# -- clear screen

$bitmap = ($Y + 1).times.map { ($X + 1).times.map { [255,255,255] } }

def set x, y, r, b, g
  return if y < 0 || y >= $bitmap.length || x < 0 || x >= $bitmap[0].length
  $bitmap[y][x] = [r, g, b]
  nil
end

# -- draw path

def tween a, z, progress
  distance = z - a
  travelled = distance * progress
  a + travelled
end

($steps - 2).times do |_step|
  step = _step + 1

  # FIXME: SQRT(2)
  how_far_along = Rational(step, $steps - 1)

  x1 = tween 0, $A, how_far_along # ORIGIN->ANCHOR1
  x2 = tween $U,$X, how_far_along # ANCHOR2->END
  x = tween x1, x2, how_far_along # actual point

  y1 = tween $Y, $B, how_far_along # ORIGIN->ANCHOR1
  y2 = tween $V,$Y, how_far_along # ANCHOR2->END
  y = tween y1, y2, how_far_along # actual point

  # -- draw real point

  g = tween(0, 255, how_far_along).to_i

  set x.to_i,y.to_i, 0,g,255-g
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

# -- draw anchors, if on-screen

set $A,$B, 191,0,191
set $A-1,$B-1, 191,0,191
set $A+1,$B-1, 191,0,191
set $A+1,$B+1, 191,0,191
set $A-1,$B+1, 191,0,191

set $A-2,$B-2, 191,0,191
set $A+2,$B-2, 191,0,191
set $A+2,$B+2, 191,0,191
set $A-2,$B+2, 191,0,191

set $U,$V, 191,255,0
set $U-1,$V-1, 191,255,0
set $U+1,$V-1, 191,255,0
set $U+1,$V+1, 191,255,0
set $U-1,$V+1, 191,255,0

set $U-2,$V-2, 191,255,0
set $U+2,$V-2, 191,255,0
set $U+2,$V+2, 191,255,0
set $U-2,$V+2, 191,255,0

# == END OF PROGRAM

$stdout.write $bitmap.flatten.pack('C*')
