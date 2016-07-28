
require_relative 'generic_list'

##
# This is effectively an implementation of O(n**2) insertion sort.
# Not efficient for actually sorting values.
class SortedList < GenericList

  ##
  # @yield a, b  => -1, 0, 1
  def initialize &comparator
    @proc = comparator
    super()
  end

  ##
  # Add new node to the list.
  def add value
    if @head.nil?
      @length = 1
      @head = GenericList::Node.new(value)
    else
      lst = @head
      ptr = @head.nxt
      while ptr && @proc.call(value, lst.value) <= 0
        lst = ptr
        ptr = ptr.nxt
      end
      @length += 1
      lst.insert value
    end
  end

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

end

