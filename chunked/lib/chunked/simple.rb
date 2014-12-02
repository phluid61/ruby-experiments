
module Chunked
	class Simple

		##
		# Creates a new Simple chunking object.
		#
		# @param chunk_size the minimum size (in bytes) of data to process
		# @param padding bytes to append to the buffer when finalising, if required (nil = no padding)
		# @param pump_proc whenever the chunker receives data, it is yielded to this proc.
		#
		def initialize chunk_size=1, padding=nil, &pump_proc
			@buffer = ''.force_encoding('ASCII-8BIT')
			@chunk_size = chunk_size
			@padding   = padding
			@pump_proc = pump_proc
		end

		##
		# Pushes a new chunk onto the end of the Simple chunker's buffer.
		# This may result in the +pump_proc+ being invoked.
		#
		# @param str the chunk of data to push.
		#
		def push str
			@buffer << str
			pump
			self
		end
		alias :<< :push

		##
		# Finalises the Simple chunker.  This ensures that any remaining
		# data in the buffer is yielded to the +pump_proc+
		#
		def finalize
			return if @buffer.empty?
			if @padding
				@buffer << @padding while @buffer.length < @chunk_size
				len = @buffer.length
				lenX = len - (len % @chunk_size)
				@buffer[lenX..-1] = '' if lenX > 0
			end
			pump(true)
			nil
		end
		alias :finalise :finalize

		#
		# If the buffer is long enough,
		# Invoked by #push and #finalize.
		#
		def pump force=false #:nodoc:
			while @buffer.length >= @chunk_size
				@pump_proc.call @buffer.slice!(0, @chunk_size)
			end
			if force && !@buffer.empty?
				@pump_proc.call @buffer
			end
		end
		private :pump

	end
end

