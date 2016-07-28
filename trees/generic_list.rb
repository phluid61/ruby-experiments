
##
# Should not be instantiated directly.
# See subclasses, like OrderedList and SortedList
class GenericList
  class Node
    def initialize value, nxt=nil, prv=nil
      @value = value
      @nxt = nxt
      @prv = prv
    end
    attr_accessor :value
    attr_accessor :nxt, :prv

    ##
    # Create a new node and insert it after this one.
    def insert_after value
      node = Node.new value, @nxt, self
      @nxt.prv = node if @nxt
      @nxt = node
    end
    alias :insert :insert_after

    ##
    # Create a new node and insert if before this one.
    def insert_before value
      node = Node.new value, self, @prv
      @prv.nxt = node if @prv
      @prv = node
    end

    ##
    # Remove this node.
    # Returns a pointer to the nxt node.
    def remove
      @nxt.prv = @prv if @nxt
      @prv.nxt = @nxt if @prv
    end
  end

  include Enumerable

  def initialize
    @head = nil
    @length = 0
  end
  attr_reader :length

  ##
  # Remove value from list.
  #
  # @param value  value to delete
  # @param n      max number to remove (<1 means "all")
  # @return value or nil
  def delete value, n=0
    return if @head.nil?
    x = n # remember value (see end of function)
    while @head && @head.value == value
      @length -= 1
      @head = @head.remove
      n -= 1
      return value if n == 0
      any = true
    end
    ptr = @head
    while ptr
      if ptr.value == value
        @length -= 1
        ptr = ptr.remove
        n -= 1
        return value if n == 0
      else
        ptr = ptr.nxt
      end
    end

    value if x != n
  end

  ##
  # Invoke block once for each value in the list.
  def each &block
    return enum_for(:each) unless block_given?
    ptr = @head
    while ptr
      yield ptr.value
      ptr = ptr.nxt
    end
    nil
  end

end

