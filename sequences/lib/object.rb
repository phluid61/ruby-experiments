
require_relative 'core'

class ObjectSequence < Sequence
	def initialize *args
		super
		@data = []
	end
	def length
		@data.length
	end
	def fetch(i,*rest,&block)
		case rest.length
		when 0; return missing_item(i,&block) if i >= @data.length
		when 1; return rest[0] if i >= @length
		else raise ArgumentError, "wrong number of arguments (#{rest.length+1} for 1..2)"
		end
		@data[i]
	end
	def store(i,obj)
		@data[i] = obj
	end
	alias :[]= :store
	def cast(obj)
		obj
	end
	def subsequence(start, length=nil)
		return ObjectSequence.new if length == 0
		if length
			tmp = @data[start,length]
		else
			tmp = @data[start..-1]
		end
		ObjectSequence.new.instance_eval{
			@data = tmp
			self
		}
	end
	def each(&block)
		return to_enum{@data.length} unless block_given?
		@data.each(&block)
		self
	end
	def push(obj)
		@data.push(obj)
		self
	end
	def pop
		@data.pop
	end
	def unshift(obj)
		@data.unshift(obj)
		self
	end
	def shift
		@data.shift
	end

	def to_a
		@data.dup
	end
	def inspect
		if @data.empty?
			"#<ObjectSequence:->"
		else
			data = @data.map{|o| o.inspect }.join(',')
			"#<ObjectSequence:#{data}>"
		end
#		"#<ObjectSequence##{@data.length}>"
	end

	def ObjectSequence.from_a(a)
		ObjectSequence.new.instance_eval{
			@data = a.dup
			self
		}
	end
end
