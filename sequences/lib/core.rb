
class Sequence
	include Enumerable

	def item(index)
		raise "Not Implemented"
	end

	def subsequence(start, length=nil)
		raise "Not Implemented"
	end

	def each(&block)
		raise "Not Implemented"
	end

	def push(item)
		raise "Not Implemented"
	end
	def pop
		raise "Not Implemented"
	end

	def unshift(item)
		raise "Not Implemented"
	end
	def shift
		raise "Not Implemented"
	end

	def rotate(n=1)
		case n <=> 0
		when -1
			(-n).times{ unshift pop }
		when  1
			n.times{ push shift }
		end
		self
	end

	def to_a
		each.to_a
	end
end
