class Calculator

  def initialize i
    @value = i
    @operator = nil
  end

  def << x
    if @operator
      @value = self.evaluate x
      @operator = nil
    else
      m = @value.method x
      a = m.arity
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

  def evaluate *args
    if @operator
      @value.__send__ @operator, *args
    elsif @operator
      [@value, @operator]
    else
      @value
    end
  end

  def to_s
    self.evaluate.to_s
  end

  # Duplicate this for more number names
  def one
    self << 1
  end

  # Duplicate this for more operations
  def add
    self << :+
  end

end

def one
  Calculator.new 1
end

puts one.add.one
