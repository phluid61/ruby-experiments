using module DeepFreeze
	refine Array do
		def deep_freeze
			each do |item| 
				if item.respond_to? :deep_freeze
					item.deep_freeze
				else
					item.freeze rescue nil
				end
			end
			freeze
		end
	end
	self
end
 
[1,[2,[3,4],5]].deep_freeze
