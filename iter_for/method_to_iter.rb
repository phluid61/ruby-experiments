require_relative 'to_iter'

# Note: this conflicts with Object#to_iter
class Method
  def to_iter *args
    Iterator.new receiver, name, *args
  end
end
