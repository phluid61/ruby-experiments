require_relative 'weighted-prng.rb'

class BayesianPRNG < WeightedPRNG
	def rand_n
		val = super
		@distribution << val
		val
	end
end

