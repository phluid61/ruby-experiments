
require 'base64'

module Chunked
  class Base64Encoder

    ##
    # Creates a new Base64Encoder object.
    #
    # @param pump_proc whenever the decoder has enough data to encode, the encoded segment is yielded to this proc.
    #
    def initialize &pump_proc
      @buffer = ''
      @pump_proc = pump_proc
    end

    ##
    # Pushes a new chunk onto the end of the Base64Encoder's buffer.
    # This may result in the +pump_proc+ being invoked.
    #
    # @param str the chunk of plaintext or binary data to push.
    #
    def push str
      @buffer << str
      len = @buffer.length
      len3 = len - (len % 3)
      @pump_proc.call( Base64.encode64 @buffer[0...len3] ) if len3 > 0
      @buffer = @buffer[len3..-1]
      self
    end
    alias :<< :push

    ##
    # Finalises the Base64Encoder.  This ensures that any remaining
    # data in the buffer is encoded and yielded to the +pump_proc+
    #
    def finalize
      return if @buffer.empty?
      @pump_proc.call( Base64.encode64 @buffer )
      nil
    end
    alias :finalise :finalize

  end
end

