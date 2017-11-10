class Calculator

  DEFAULT_OP = :*

  def initialize i=nil
    i = i.value if i.is_a? Calculator
    @stack = []
    @value = i
    @operator = nil
  end

  def push i=nil
    i = i.value if i.is_a? Calculator
    @stack.push [@value, @operator || Calculator::DEFAULT_OP]
    @value = i
    @operator = nil

    self
  end

  def pop
    raise "empty stack" if @stack.empty?
    rhs, @value, @operator = value, *@stack.pop
    self << rhs
  end

  def << x
    x = x.value if x.is_a? Calculator
    if @value.nil?
      @value = x
      @operator = nil
    elsif @operator
      @value = self.evaluate x
      @operator = nil
    else
      m = @value.method x
      raise "unknown operation #{@value.inspect}.#{x.inspect}" unless m
      a = m.arity
      a = -a - 1 if a < 0 # best guess
      if a > 1
        raise "can't do multiple-arity operations"
      else
        @operator = x
        if a == 0
          @value = self.evaluate
          @operator = nil
        end
      end
    end
    self
  end
  alias :__insert__ :<<

  def evaluate *args
    if @operator
      @value.__send__ @operator, *args
    elsif @operator
      [@value, @operator]
    else
      @value
    end
  end

  def value
    raise "unresolved operator #{@operator.inspect}" if @operator
    @value
  end

  def to_s
    value.to_s
  end

  def define_method *foo, &bar
    singleton_class.__send__ :define_method, *foo, &bar
  end
  module Dynamic
    def __value__ value, name, *aliases
      define_method(name.to_sym) { self << value }
      aliases.each {|a| alias_method a.to_sym, name.to_sym }
      name.to_sym
    end
    def __unary__ op, name, *aliases
      define_method(name.to_sym) {|thing| push(thing).__insert__(op.to_sym).pop }
      aliases.each {|a| alias_method a.to_sym, name.to_sym }
      name.to_sym
    end
    def __binary__ op, name, *aliases
      define_method(name.to_sym) {|i=nil| (self << op.to_sym).tap{|_| _ << i if i} }
      aliases.each {|a| alias_method a.to_sym, name.to_sym }
      name.to_sym
    end
  end
  extend self::Dynamic
  include self::Dynamic

  # Named values
  __value__ 0, :zero
  __value__ 1, :one
  __value__ 2, :two
  __value__ 3, :three
  __value__ 4, :four
  __value__ 5, :five
  __value__ 6, :six
  __value__ 7, :seven
  __value__ 8, :eight
  __value__ 9, :nine
  __value__ 10,:ten

  # Named operations
  def open_bracket() push; end
  def close_bracket() pop; end

  __unary__ :-@,  :negative
  __unary__ :abs, :positive
  __unary__ :~,   :bit_not

  __binary__ :+,  :add,      :plus
  __binary__ :-,  :subtract, :minus
  __binary__ :*,  :multiply, :times
  __binary__ :/,  :divide,   :divided_by
  __binary__ :%,  :modulus,  :modulo, :mod
  __binary__ :**, :exponent, :to_the_power_of, :to_the
  __binary__ :&,  :bit_and
  __binary__ :|,  :bit_or
  __binary__ :^,  :bit_xor
  __binary__ :<<, :lshift,   :shift_left
  __binary__ :>>, :rshift,   :shift_right

  def x(i=nil)
    (self << :to_s << :*).tap{|_| _ << i if i}
  end

end

def one()   Calculator.new 1; end
def two()   Calculator.new 2; end
def three() Calculator.new 3; end
def open_bracket() Calculator.new.open_bracket; end
def negative(x) Calculator.new.negative(x); end

def check desc, expected, actual
  actual = actual.value if actual.is_a? Calculator
  desc = "#{desc} " if desc
  puts "#{desc}\e[36m#{expected.inspect}\e[0m => \e[#{actual == expected ? 32 : 31}m#{actual.inspect}\e[0m"
end

# check combinations of syntax
check '1 + 1   =', 2, one.add.one
check '(1+2)/3 =', 1, open_bracket.one.plus.two.close_bracket.divided_by.three
check '(1+2)/3 =', 1, Calculator.new(one.plus.two).divided_by(three)
check '1 + -1  =', 0, one.plus.negative(one)
check '1 + -1  =', 0, one.plus(negative(one))
check '2(3)    =', 6, two.open_bracket.three.close_bracket
check '1 x 3   =', '111', one.x.three

# check precedence
check '1+2*3   =', 9, one.plus.two.times.three # yes, really
check '1+(2*3) =', 7, one.plus.open_bracket.two.times.three.close_bracket
check '1+(2*3) =', 7, one.plus(two.times.three)

# check support for arbitrary/ad-hoc values
check '{100-50}.chr+"a" =', '2a', (Calculator.new(100).minus << 50 << :chr).plus << 'a'

# check support for custom nodes
calc = Calculator.new
calc.__value__ 3.14, :pi
check nil, 3.14, calc.pi
#Calculator.new.pi => NoMethodError

