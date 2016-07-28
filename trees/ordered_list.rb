
require_relative 'generic_list'

class OrderedList < GenericList

  def initialize
    super
    @tail = nil
  end

  ##
  # Add new node to end of list.
  def push value
    if @head.nil?
      @length = 1
      @head = @tail = GenericList::Node.new(value)
    else
      @length += 1
      @tail = @tail.insert value
    end
  end

  ##
  # Remove node from end of list, and return its value.
  def pop &block
    if @tail.nil?
      yield if block_given?
    else
      @length -= 1
      node = @tail
      @tail = @tail.remove
      node.value
    end
  end

  ##
  # Add a new node to the start of the list.
  def unshift value
    if @head.nil?
      @length = 1
      @head = @tail = GenericList::Node.new(value)
    else
      @length += 1
      @head = @head.insert_before value
    end
  end

  ##
  # Remove node from start of list, and return its value.
  def shift &block
    if @head.nil?
      yield if block_given?
    else
      @length -= 1
      node = @head
      @head = @head.remove
      node.value
    end
  end
end

