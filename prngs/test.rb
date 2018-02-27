require_relative 'weighted-prng'
require_relative 'bayesian-prng'
require_relative 'evolving-prng'
require_relative 'xorshift-prng'
require_relative 'poly-prng'

def test prng, t=100, quiet=false
  h = Hash.new(0)
  print '    ' unless quiet
  puts prng.diagnostic unless quiet
  t.times do
    i = prng.rand prng.domain
    print( '%2d> ' % i ) unless quiet
    h[i] += 1
    puts prng.diagnostic unless quiet
  end
  puts "- -" unless quiet
  p h.to_a.sort_by{|a,b|-b}.map{|a,b|[a,b,b*100.0/t]}
  puts "---" unless quiet
end

def raw_test prng, buckets, runs
  h = Hash.new(0)
  runs.times do
    i = prng.rand buckets
    h[i] += 1
  end
  h
end

def awesomeplot prng, buckets, runs=1000, results=nil
  prng = prng.new buckets if prng.is_a? Class
  results = raw_test( prng, buckets, runs )
  peak = results.values.max
  if runs == 100
    top = peak + 1
  else
    top = (peak * 100.0 / runs).round + 1
  end
  top.times do |j|
    print( '%3d%% ' % (top-j) )
    buckets.times do |x|
      if runs == 100
        y = results[x]
      else
        y = (results[x] * 100.0 / runs).round
      end
      l = top - j
      print( y >= l ? ' # ' : ( l == 1 ? ' _ ' : '   ' ) )
    end
    print "\n"
  end
  print '     '
  buckets.times do |x|
    print( '%-3s' % ('%2d' % (x+1)) )
  end
  print "\n"
end

#puts "Weighted"
##test( WeightedPRNG.new 10 )
#test( WeightedPRNG.new(10, 9087123987), 100, true )

#puts "Bayesian"
##test( BayesianPRNG.new 10 )
#test( BayesianPRNG.new(10), 100, true )
#test( BayesianPRNG.new(10), 500, true )
#test( BayesianPRNG.new(10), 1000, true )
#test( BayesianPRNG.new(10), 5000, true )
#test( BayesianPRNG.new(10), 10000, true )

#puts "Evolving"
##test( EvolvingPRNG.new 10 )
#test( EvolvingPRNG.new(10), 100, true )
#test( EvolvingPRNG.new(10), 500, true )
#test( EvolvingPRNG.new(10), 1000, true )
#test( EvolvingPRNG.new(10), 5000, true )
#test( EvolvingPRNG.new(10), 10000, true )

puts '---'
awesomeplot WeightedPRNG, 50
puts '', 'Bayesian:'
p = BayesianPRNG.new(50)
awesomeplot p, 50, 1_000
awesomeplot p, 50, 1_000
awesomeplot p, 50, 1_000
puts '', 'Evolving:'
p = EvolvingPRNG.new(50)
awesomeplot p, 50, 500
awesomeplot p, 50, 500
awesomeplot p, 50, 500
puts '---'
puts '', 'xorshift-32:'
p = Xorshift32PRNG.new
awesomeplot p, 50, 100
awesomeplot p, 50, 100
puts '', 'xorshift-128:'
p = Xorshift128PRNG.new
awesomeplot p, 50, 100
awesomeplot p, 50, 100
puts '', 'xorwow:'
p = XorwowPRNG.new
awesomeplot p, 50, 100
awesomeplot p, 50, 100
puts '', 'xorshift*:'
p = XorshiftStarPRNG.new
awesomeplot p, 50, 100
awesomeplot p, 50, 100
puts '', 'xorshift1024*:'
p = Xorshift1024StarPRNG.new
awesomeplot p, 50, 100
awesomeplot p, 50, 100
puts '', 'xorshift128+:'
p = Xorshift128PlusPRNG.new
awesomeplot p, 50, 100
awesomeplot p, 50, 100
puts '---'
puts '', 'polyhedron:'
p = PolyPRNG.new
awesomeplot p, 50, 100
awesomeplot p, 50, 100
awesomeplot p, 50, 100
puts '---'

