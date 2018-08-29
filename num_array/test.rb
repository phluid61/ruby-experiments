
require_relative 'num_array'

class Object
  def self
    if block_given?
      yield self
    else
      self
    end
  end
end

a = [1, 10, 8, 4, 3, 2, 1, 8, 8, 2, 5, 5, 9, 7, 8, 3, 6, 7, 1, 4, 4, 5, 10, 9, 4]
b = [10, 10, 6, 7, 5, 3, 7, 1, 3, 1, 4, 9, 1, 6, 8, 4, 7, 1, 7, 4]
c = [
  2.6979180022058746,
  6.438653010357816,
  5.613233021379376,
  1.026268445041314,
  5.950911423044285,
  3.6177279518130137,
  5.729429334859625,
  4.551306266131486,
  4.415358800741308,
  0.6867980333190515,
  9.761533229181431,
  5.351751726543777,
]
d = [
  Rational(1,1),
  Rational(2,3),
  Rational(2,3),
  Rational(3,1),
  Rational(1,2),
  Rational(3,1),
  Rational(2,1),
  Rational(3,1),
  Rational(1,3),
]

[a, b, c, d].each do |x|
  puts "---"
  p x
  p x.sort
  p Hash[x.group_by(&:self).map{|i,j|[i,j.length]}.sort_by{|i,j|-j}]
  print "Length:  "; p x.length
  print "Mean:    "; p x.mean
  print "FMean:   "; p x.fmean
  print "Mode:    "; p x.mode
  print "MMode:   "; p x.multimode
  print "Median:  "; p x.median
  print "FMedian: "; p x.fmedian
end
