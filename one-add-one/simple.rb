class Numeric
  def add
    LHS_Op.new self, :+
  end
end

class LHS_Op
  def initialize i, o
    @lhs = i
    @op = o
  end
  def one
    @lhs.__send__ @op, 1
  end
end

def one
  1
end

p one
p one.add
p one.add.one
