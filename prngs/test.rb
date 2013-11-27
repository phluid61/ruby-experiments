require_relative 'weighted-prng.rb'
require_relative 'bayesian-prng.rb'
require_relative 'evolving-prng.rb'

def test prng, t=100, quiet=false
	h = Hash.new(0)
	print '    ' unless quiet
	puts prng.diagnostic unless quiet
	t.times do
		i = prng.rand(prng.domain)
		print( '%2d> ' % i ) unless quiet
		h[i] += 1
		puts prng.diagnostic unless quiet
	end
	puts "- -" unless quiet
	p h.to_a.sort_by{|a,b|-b}.map{|a,b|[a,b,b*100.0/t]}
	puts "---" unless quiet
end
def raw_test prng, t
	h = Hash.new(0)
	t.times do
		i = prng.rand(prng.domain)
		h[i] += 1
	end
	h
end
def awesomeplot prng, width, t=1000, results=nil
	prng = prng.new width unless prng.is_a? WeightedPRNG
	results = raw_test( prng, t )
	peak = results.values.max
	top = (peak * 100.0 / t).round + 1
	top.times do |j|
		print( '%3d%% ' % (top-j) )
		width.times do |x|
			y = (results[x] * 100.0 / t).round
			l = top - j
			print( y >= l ? ' x ' : '   ' )
		end
		print "\n"
	end
	print '     '
	width.times do |x|
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
awesomeplot p, 50, 1_000
awesomeplot p, 50, 1_000
puts '', 'Evolving:'
p = EvolvingPRNG.new(50)
awesomeplot p, 50, 500
awesomeplot p, 50, 500
awesomeplot p, 50, 500
awesomeplot p, 50, 500
awesomeplot p, 50, 500
puts '---'

