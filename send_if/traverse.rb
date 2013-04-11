
module Traversal
	def traverse *path, &block
		obj = self
		while !path.empty? and obj.respond_to? :shift
			obj = obj.fetch(path.shift) do |k|
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

