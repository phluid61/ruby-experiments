
class Object
	def self &block
		if block_given?
			yield self
		else
			self
		end
	end
end
