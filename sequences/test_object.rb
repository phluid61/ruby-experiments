$VERBOSE = true
require_relative 'sequences'

$obj = Object.new

# test initialisation
p ObjectSequence.new
p ObjectSequence.from_a(['a',1,$obj])

# arrayification
p ObjectSequence.new.to_a
p ObjectSequence.from_a(['a',1,$obj]).to_a

# test subsequences
puts ''
4.times{|i| p [i, ObjectSequence.from_a(['a',1,$obj]).subsequence(i)] }
puts ''
3.times{|j|
	(4-j).times{|i| p [[j,i],ObjectSequence.from_a(['a',1,$obj]).subsequence(j,i)] }
	puts ''
}

# push (right)
p ObjectSequence.from_a(['a',1,$obj]).tap{|bits|
	3.times{ bits.push('x') }
}

# pop
bs = ObjectSequence.from_a(['a',1,$obj])
p [bs.pop, bs]

# unshift (left)
p ObjectSequence.from_a(['a',1,$obj]).tap{|bits|
	3.times{ bits.unshift('x') }
}

# shift
bs = ObjectSequence.from_a(['a',1,$obj])
p [bs.shift, bs]

# rotate nil
p ObjectSequence.from_a(['a',1,$obj]).tap{|bits|
	bits.rotate 0
}

# rotate left
p ObjectSequence.from_a(['a',1,$obj]).tap{|bits|
	bits.rotate 1
}
p ObjectSequence.from_a(['a',1,$obj]).tap{|bits|
	bits.rotate 2
}

# rotate right
p ObjectSequence.from_a(['a',1,$obj]).tap{|bits|
	bits.rotate -1
}
p ObjectSequence.from_a(['a',1,$obj]).tap{|bits|
	bits.rotate -2
}
