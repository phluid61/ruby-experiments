
class String
	def rb_blank?
		/\A[[:space:]]*\z/ =~ self
	end
end

