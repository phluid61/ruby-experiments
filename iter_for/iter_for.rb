class Iterator < Enumerator
  def initialize obj, meth, *args
    super() do |y|
      loop do
        y << obj
        obj = obj.send(meth, *args)
      end
    end
  end
end

class Object
  def iter_for meth, *args
    Iterator.new self, meth, *args
  end
  alias :to_iter :iter_for
end
