$nesting = 0

class AndAndDelegator
	def initialize o
		@o = o
		@chain = []
	end
	def _!
		@chain.inject(@o) do |o,x|
			a,b = x
			break o unless o
			o.__send__(*a, &b)
		end
	end
	def method_missing *a, &b
		@chain << [a,b]
		self
	end
	def _?
		@chain << [[:'_?'],nil]
		self
	end
end

class Object
	def _?
		AndAndDelegator.new(self)
	end
end
