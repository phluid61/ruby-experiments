
class MaybeDelegator
	def initialize o
		@o = o
	end
	def maybe
		self
	end
	def method_missing *a, &b
		@o && @o.send(*a, &b)
	end
end

class Object
	def maybe &b
		if b
			self && instance_eval(&b)
		else
			MaybeDelegator.new(self)
		end
	end
end
