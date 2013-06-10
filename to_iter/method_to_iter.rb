# Note: this conflicts with Object#to_iter
class Method
  def to_iter *args
    obj = receiver
    Enumerator.new do |y|
      loop do
        y << obj
        obj = obj.send(name, *args)
      end
    end
  end
end
