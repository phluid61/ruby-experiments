
$BLANK_REGEX = /\A[[:space:]]*\z/

class String
	BLANK_REGEX = /\A[[:space:]]*\z/

	def const_blank?
		String::BLANK_REGEX =~ self
	end

	def glob_blank?
		$BLANK_REGEX =~ self
	end

	def rb_blank?
		/\A[[:space:]]*\z/ =~ self
	end
end

