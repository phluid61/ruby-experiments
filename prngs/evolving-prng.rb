require_relative 'weighted-prng.rb'

class EvolvingPRNG < WeightedPRNG
	SCALE = 20

	def rand_n
		stronger = @distribution[ @prng.rand(@distribution.length) ]
		weaker   = @inverse[ @prng.rand(@inverse.length) ]
		while @counts[weaker] < 2
			# no extinction here; next victim
			weaker = @inverse[ @prng.rand(@inverse.length) ]
		end
		if stronger != weaker
			@distribution.delete_at @distribution.index(weaker)
			@distribution << stronger
			#__update
			@inverse.delete_at @inverse.index(stronger)
			@inverse << weaker
			@counts[weaker] -= 1
			@counts[stronger] += 1
		end
		stronger
	end

	def srand s=nil
		old = @s
		# update the underlying PRNG
		if s
			@prng = Random.new(s)
		else
			s = @prng.rand @n
		end
		# update my state
		@s = s
		@distribution = (0...@n).to_a # at least one of each
		(@n * (SCALE-1)).times do # now fill out the rest
			@distribution << @prng.rand( @n )
		end
		__update
		# return the old seed
		old
	end

	def __update
		total = @n * SCALE
		@counts = Hash[ @distribution.group_by{|x|x}.map{|k,v|[k,v.length]} ]
		@inverse = []
		(0...@n).each do |i,n|
			@inverse += [i] * (total - @counts[i])
		end
	end
	private :__update
end

