$VERBOSE = true
require_relative 'sequences'

# test initialisation
p BitSequence.new
p BitSequence.from_i(0b10101100)

# arrayification
p BitSequence.new.to_a
p BitSequence.from_i(0b10101100).to_a

# intification
p BitSequence.new.to_i
p BitSequence.from_i(0b10101100).to_i

# stringification
p BitSequence.new.to_s
p BitSequence.from_i(0b10101100).to_s

# test subsequences
puts ''
9.times{|i| p [i, BitSequence.from_i(0b10101100).subsequence(i)] }
puts ''
8.times{|j|
	(9-j).times{|i| p [[j,i],BitSequence.from_i(0b10101100).subsequence(j,i)] }
	puts ''
}

# push (right)
p BitSequence.from_i(0b101).tap{|bits|
	3.times{ bits.push(1) }
}

# pop
bs = BitSequence.from_i(0b101)
p [bs.pop, bs]

# unshift (left)
p BitSequence.from_i(0b101).tap{|bits|
	3.times{ bits.unshift(1) }
}

# shift
bs = BitSequence.from_i(0b101)
p [bs.shift, bs]

# rotate nil
p BitSequence.from_i(0b1100).tap{|bits|
	bits.rotate 0
}

# rotate left
p BitSequence.from_i(0b1100).tap{|bits|
	bits.rotate 1
}
p BitSequence.from_i(0b1100).tap{|bits|
	bits.rotate 2
}

# rotate right
p BitSequence.from_i(0b1100).tap{|bits|
	bits.rotate -1
}
p BitSequence.from_i(0b1100).tap{|bits|
	bits.rotate -2
}
