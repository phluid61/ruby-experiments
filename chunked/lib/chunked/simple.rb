
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
      raise ArgumentError, 'chunk size must be >= 1' if chunk_size < 1
      @buffer = self.class.new_buffer
      @chunk_size = chunk_size
      if @padding
        @padding = ('' << padding).freeze
      else
        @padding = nil
      end
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
    # Returns true iff the buffer is empty.
    #
    def empty?
      @buffer.empty?
    end

    #
    # Returns the number of available bytes in the buffer.
    #
    def free_space
      @chunk_size - @buffer.length
    end

    #
    # Flush any data in the buffer.
    #
    # opts:
    # * :drop     => true (false)   don't emit to @pump_proc
    # * :partial  => true (false)   don't pad to @chunk_size
    # * :padding  => String (@padding)
    # * :empty    => true (false)   even if empty
    #
    def flush opts={}
      if opts[:drop]
        @buffer = self.class.new_buffer
        return
      elsif @buffer.empty? && !opts[:empty]
        return
      end
      if !opts[:partial]
        padding = opts.fetch(:padding, @padding)
        if padding
          @buffer << padding while @buffer.length < @chunk_size
          len = @buffer.length
          lenX = len - (len % @chunk_size)
          @buffer[lenX..-1] = '' if lenX > 0
        end
      end
      pump true
      nil
    end

    #
    # Have a peek at what's in the buffer.
    #
    def peek
      @buffer.dup
    end

    #
    # If the buffer is long enough, feed it in appropriately-sized chunks
    # to the pump_proc.
    #
    # Invoked by #push and #finalize.
    #
    def pump force=false #:nodoc:
      while @buffer.length >= @chunk_size
        @pump_proc.call @buffer.slice!(0, @chunk_size)
      end
      if force && !@buffer.empty?
        # clear the buffer before calling the proc
        buff = @buffer
        @buffer = self.class.new_buffer
        @pump_proc.call buff
      end
    end
    private :pump

    def inspect #:nodoc:
      "#<#{self.class.inspect}:#{__id__.to_s 16} [#{@chunk_size-@buffer.length}/#{@chunk_size}] #{@padding.inspect}>"
    end

    class << self
      def new_buffer #:nodoc:
        ''.force_encoding('ASCII-8BIT')
      end
    end

  end
end

