
# Load native #blank? from the .so
require './str_blank'

class String
	# Check if the string is blank.
	def rb_blank?
		/\A[[:space:]]*\z/ =~ self
	end
end

