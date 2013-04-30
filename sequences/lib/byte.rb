
class Byte
	def initialize b
		case b
		when nil
			@i = 0
		when String
			b = b.unpack('CC')
			warn "WARNING: truncating long string" if b[1]
			@i = b.first
		when Integer
			warn "WARNING: truncating long integer" if b < 0 || b > 0xFF
			@i = b & 0xFF
		when Byte
			@i = b.to_i
		else
			raise ArgumentError, "not a byte"
		end
	end
	def to_i
		@i
	end
	def to_s
		@i.chr#.force_encoding(Encoding::ASCII_8BIT)
	end
	def inspect
		"#<Byte:0x#{@i.to_s 16}>"
	end
end

def Byte(b)
	Byte.new(b)
end

require_relative 'core'

class ByteSequence < Sequence
	def initialize *args
		super
		@data = ''.force_encoding(Encoding::ASCII_8BIT)
	end
	def length
		@data.length
	end
	def item(i)
		Byte(@data[i])
	end
	alias :[] :item
	def store(i,byte)
		byte = Byte(byte)
		if i > @data.length
			@data << ("\0" * (i - @data.length)) + byte.to_s
		else
			@data[i..i] = byte.to_s
		end
		byte
	end
	alias :[]= :store
	def cast(byte)
		byte.is_a?(Byte) ? byte : Byte(byte)
	end
	def subsequence(start, length=nil)
		if length
			tmp = @data[start,length]
		else
			tmp = @data[start..-1]
		end
		ByteSequence.new.instance_eval{
			@data = tmp
			self
		}
	end
	def each(&block)
		return to_enum{@data.size} unless block_given?
		@data.each_byte{|b| yield Byte(b) }
		self
	end
	def push(byte)
		b = Byte(byte)
		@data << b.to_s
		self
	end
	def pop
		return nil if @data.empty?
		b = Byte(@data[-1])
		@data = @data[0...-1]
		b
	end
	def unshift(byte)
		b = Byte(byte)
		@data = "#{b}#@data"
		self
	end
	def shift
		return nil if @data.empty?
		b = Byte(@data[0])
		@data = @data[1..-1]
		b
	end

	def to_s
		@data.dup
	end
	def to_a
		@data.each_byte.map{|b| Byte(b) }
	end
	def inspect
		if @data.empty?
			bytes = '-'
		else
			bytes = @data.each_byte.map{|b| '%02X' % b }.join(',')
		end
		"#<ByteSequence:#{bytes}>"
	end

	def ByteSequence.from_s(s)
		ByteSequence.new.instance_eval{
			@data = s.to_s
			self
		}
	end
end
