
module Traversal
  def traverse *path, &block
    obj = self
    while !path.empty? and (fobj = Traversal.fetchable(obj))
      obj = fobj.fetch(path.shift) do |k|
        return yield obj, k if block_given?
        return Traversal.default(obj, k)
      end
    end
    if !path.empty?
      return yield obj, nil if block_given?
      return nil
    end
    obj
  end

  def Traversal.fetchable obj
    if obj.respond_to? :fetch
      obj
    elsif obj.respond_to? :to_h
      obj.to_h
    elsif obj.respond_to? :to_a
      obj.to_a
    end
  end

  def Traversal.default obj, k
    if obj.respond_to?(:default_proc) && (p = obj.default_proc)
      p.call(obj, k)
    elsif obj.respond_to?(:default)
      obj.default
    end
  end
end

class Hash
  include Traversal
end

class Array
  include Traversal
end

# For the lawls
class Thread
  def to_h
    keys.inject({}) {|h,k| h[k] = self[k] }
  end
end
