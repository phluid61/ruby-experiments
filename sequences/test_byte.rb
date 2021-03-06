$VERBOSE = true
require_relative 'sequences'

# test initialisation
p ByteSequence.new
p ByteSequence.from_s("abcd")

# arrayification
p ByteSequence.new.to_a
p ByteSequence.from_s("abcd").to_a

# intification
#p ByteSequence.new.to_i
#p ByteSequence.from_s("abcd").to_i

# stringification
p ByteSequence.new.to_s
p ByteSequence.from_s("abcd").to_s

# test subsequences
puts ''
5.times{|i| p [i, ByteSequence.from_s("abcd").subsequence(i)] }
puts ''
4.times{|j|
  (5-j).times{|i| p [[j,i],ByteSequence.from_s("abcd").subsequence(j,i)] }
  puts ''
}

# push (right)
p ByteSequence.from_s("abc").tap{|bytes|
  3.times{ bytes.push('x') }
}

# pop
bs = ByteSequence.from_s("abc")
p [bs.pop, bs]

# unshift (left)
p ByteSequence.from_s("abc").tap{|bytes|
  3.times{ bytes.unshift('x') }
}

# shift
bs = ByteSequence.from_s("abc")
p [bs.shift, bs]

# rotate nil
p ByteSequence.from_s("abcd").tap{|bytes|
  bytes.rotate 0
}

# rotate left
p ByteSequence.from_s("abcd").tap{|bytes|
  bytes.rotate 1
}
p ByteSequence.from_s("abcd").tap{|bytes|
  bytes.rotate 2
}

# rotate right
p ByteSequence.from_s("abcd").tap{|bytes|
  bytes.rotate -1
}
p ByteSequence.from_s("abcd").tap{|bytes|
  bytes.rotate -2
}

p ByteSequence.from_s("abcd").tap{|bytes|
  bytes[1] = 'x'
}
p ByteSequence.from_s("abcd").tap{|bytes|
  bytes[4] = 'x'
}
p ByteSequence.from_s("abcd").tap{|bytes|
  bytes[5] = 'x'
}

