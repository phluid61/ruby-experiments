
class BinaryTree
  class Node
    def initialize value, parent, comparator
      @value  = value
      @parent = parent
      @left  = nil
      @right = nil
      @cmp = comparator
    end
    attr_accessor :value

    ##
    # Add a value to the tree, below this node.
    # Returns the new node.
    def add value
      if @cmp.call(@value, value) < 0
        if @left
          @left.add value, cmp
        else
          @left = Node.new value, self, @cmp
        end
      else
        if @right
          @right.add value
        else
          @right = Node.new value, self, @cmp
        end
      end
    end

    ##
    # Recursively yield left/this/right value.
    def each &block
      return enum_for(:each) unless block_given?
      @left.each(&block) if @left
      yield @value
      @right.each(&block) if @right
      nil
    end
  end

  include Enumerable

  ##
  # Create a new self-sorting binary tree.
  #
  # If called with a block, it is used as the comparison function
  # for sorting values.  By default values are compared using the
  # spaceship operator <=>
  #
  #  @yield |a, b|  =>  {-1, 0, 1}
  #
  def initialize &comparator
    comparator = lambda {|a, b| a <=> b } if !comparator
    @cmp = comparator
    @root = nil
    @length = 0
  end
  attr_reader :length

  ##
  # Add a new value to the tree.
  def add value
    if !@root
      @root = Node.new value, nil, @cmp
      @length = 1
    else
      @root.add value
      @length += 1
    end
    value
  end

  ##
  # Iterator over each element in the tree, in order.
  #
  #  @yield |value|
  def each &block
    return enum_for(:each) unless block_given?
    return if !@root
    @root.each &block
  end
end

