
class Bit
	def initialize b
		case b
		when true
			@i = 1
		when false, nil
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
	def === o
		case o
		when true
			@i == 1
		when false, nil
			@i == 0
		else
			@i = o.to_i
		end
	end
	def inspect
		"#<Bit:#{@i}>"
	end
	alias :to_s :inspect
end

def Bit(b)
	Bit.new(b)
end

require_relative 'core'

# todo: bitwise arithmetic (&, |, ^)
#       generalise for all sequences?
class BitSequence < Sequence

	def initialize *args
		super
		@data = 0
		@length = 0
	end

	def length
		@length
	end

	def fetch(i,*rest,&block)
		case rest.length
		when 0; return missing_item(i,&block) if i >= @length
		when 1; return rest[0] if i >= @length
		else raise ArgumentError, "wrong number of arguments (#{rest.length+1} for 1..2)"
		end
		Bit(@data & (1<<(@length-i-1)))
	end

	def store(i,bit,*rest,&block)
		if i >= @length
			(@length...i).each do |j|
				case rest.length
				when 0; p = missing_item(j,&block)
				when 1; p = rest[0]
				else raise ArgumentError, "wrong number of arguments (#{rest.length+2} for 2..3)"
				end
				@data = (@data << 1) | p.to_i
			end
			@data <<= 1
			@length = i + 1
		end

		bit = Bit(bit)
		if bit.to_i == 0
			@data &= ~(1<<(@length-i-1))
		else
			@data |= (1<<(@length-i-1))
		end
		bit
	end

	def cast(bit)
		bit.is_a?(Bit) ? bit : Bit(bit)
	end

	def subsequence(start, length=nil)
		raise ArgumentError, "negative numbers not allowed" if start < 0 || (length && length < 0)
		return BitSequence.new if length == 0

		a = @length - start
		return BitSequence.new if a < 0

		mask = 1
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
		return self if @length < 1
		mask = 1 << @length
		@length.times do
			mask >>= 1
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
