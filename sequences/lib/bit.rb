
class Bit
	def initialize b
		case b
		when true
			@i = 1
		when false
			@i = 0
		when Integer
			@i = (b == 0 ? 0 : 1)
		when Bit
			@i = b.to_i
		else
			raise ArgumentError, "not a bit"
		end
	end
	def to_i
		@i
	end
	def to_b
		@i != 0
	end
	def inspect
		"#<Bit:#{@i}>"
	end
end

def Bit(b)
	Bit.new(b)
end

require_relative 'core'

class BitSequence < Sequence
	def initialize
		@data = 0
		@length = 0
	end
	def length
		@length
	end
	def item(i)
		Bit(@data & (1<<i))
	end
	def subsequence(start, length=nil)
		return BitSequence.new if length == 0
		mask = 1
		a = @length - start
		(a-1).times{ mask |= (mask << 1) }
		tmp = @data & mask
		if length
			tmp >>= (a-length)
		else
			length = a
		end
		BitSequence.new.instance_eval{
			@data = tmp
			@length = length
			self
		}
	end
	def each(&block)
		return to_enum{@length} unless block_given?
		mask = 1 << @length
		@length.times do
			mask >> 1
			yield Bit(@data & mask)
		end
		self
	end
	def push(bit)
		b = Bit(bit).to_i
		@data = (@data << 1) | b
		@length += 1
		self
	end
	def pop
		return nil if @length < 1
		b = Bit(@data & 1)
		@data >>= 1
		@length -= 1
		b
	end
	def unshift(bit)
		b = Bit(bit).to_i
		@data |= (b << @length)
		@length += 1
		self
	end
	def shift
		return nil if @length < 1
		@length -= 1
		b = @data & (1 << @length)
		@data ^= b
		Bit(b)
	end

	def to_i
		@data
	end
	def to_s
		if @length > 0
			pattern = "%0#{@length}b"
			pattern % @data
		else
			''
		end
	end
	def inspect
		if @length > 0
			pattern = "%0#{@length}b"
			bits = pattern % @data
		else
			bits = '-'
		end
		"#<BitSequence:#{bits}>"
	end

	def BitSequence.from_i(i)
		BitSequence.new.instance_eval{
			@data = i
			@length = Math.log(@data,2).floor + 1
			self
		}
	end
end
