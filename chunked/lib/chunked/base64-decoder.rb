
require 'base64'

module Chunked
	class Base64Decoder

		##
		# Creates a new Base64Decoder object.
		#
		# @param pump_proc whenever the decoder has enough data to decode, the decoded segment is yielded to this proc.
		#
		def initialize &pump_proc
			@buffer = ''
			@pump_proc = pump_proc
		end

		##
		# Pushes a new chunk onto the end of the Base64Decoder's buffer.
		# This may result in the +pump_proc+ being invoked.
		#
		# @param str the chunk of Base64-encoded data to push.
		#
		def push str
			# See: RFC 2045 for this list of characters
			@buffer << str.gsub(%r@[^A-Za-z0-9+/=]@, '')
			pump
			self
		end
		alias :<< :push

		##
		# Finalises the Base64Decoder.  This ensures that any remaining
		# data in the buffer is decoded and yielded to the +pump_proc+
		#
		def finalize
			return if @buffer.empty?
			@buffer << '=' while @buffer.length < 4
			pump
			nil
		end
		alias :finalise :finalize

		#
		# If the buffer is long enough, 
		# Invoked by #push and #finalize.
		#
		def pump #:nodoc:
			len = @buffer.length
			len4 = len - (len % 4)
			@pump_proc.call( Base64.decode64 @buffer[0...len4] ) if len4 > 0
			@buffer = @buffer[len4..-1]
		end
		private :pump

	end
end

