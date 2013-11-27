
class Sequence
	include Enumerable

	def initialize(*args, &default_proc)
		if args.empty?
			@default = nil
		else
			@default = cast( args[0] )
		end
		@default_proc = default_proc
	end

	attr_reader :default
	attr_writer :default, :default_proc

	def default_proc(&new_proc)
		@default_proc = new_proc if new_proc
		@default_proc
	end

	def missing_item(index=nil,&block)
		return @default if @default
		prc = block_given? ? block : @default_proc
		if prc
			case prc.arity
			when 0
				cast prc[]
			when 1
				cast prc[index]
			else
				cast prc[index,self]
			end
		else
			cast nil
		end
	end

	def cast(item)
		raise "Not Implemented"
	end

	#
	#   fetch(i) => item
	#   fetch(i, default) => item
	#   fetch(i) { block } => item
	#   fetch(i) {|i| block } => item
	#   fetch(i) {|i, seq| block } => item
	#
	# Returns an item from the sequence for the given index +i+.
	# If the index is out of bounds, there are several options:
	# With no other arguments, the default value/proc supplied in
	# the constructor (if any) will be used; if +default+ is
	# given, then that will be returned; if the optional code block
	# is specified, then that will be run and its result returned.
	#
	def fetch(index, default=nil, &block)
		raise "Not Implemented"
	end

	def [] index
		fetch(index)
	end

	#
	# Sets the indexth element of the sequence.
	# If +index+ is off the end, intermediate values are populated
	# with padding (if defined), or block.call (if given), or the
	# default value/proc supplied in the constructor.
	#
	def store(index, item, padding=nil, &block)
		raise "Not Implemented"
	end

	def []= index, item
		store(index, item)
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
		return self if empty?
		case n <=> 0
		when -1
			(-n % length).times{ unshift pop }
		when  1
			(n % length).times{ push shift }
		end
		self
	end

	def to_a
		each.to_a
	end

	def length
		each.count
	end

	def empty?
		length == 0
	end
end
