# vim:ts=2:sw=2:sts=2

class String
	#
	# Returns an Array of Strings, which are the hexadecimal representation of
	# this String object's bytes, in columns of 32-bytes.
	#
	# When +ansi+ is either:
	#  * not given, or
	#  * given and false/nil
	# this method returns simple Strings.  Any other value for +ansi+
	# returns Strings including ANSI commands to alternate the background
	# of every four columns.
	#
	def wrap_hex ansi=false
		ary=[]
		if ansi
			g = false
			i = 0
			str=[]
			scan(/.{1,4}/m).each do |c|
				if (g = !g)
					as = "\e[100m"
					ae = "\e[0m"
				else
					as = ae = ''
				end
				str << (as + c.unpack("C*").map{|c|'%02x'%c}.join(' ') + ae)
				if (i+=1)%8 == 0
					ary << str.join(' ')
					str = []
				end
			end
			ary << str.join(' ') if str.length > 0
		else
			scan(/.{1,32}/m).each{|c|ary << c.unpack("C*").map{|c|'%02x'%c}.join(' ')}
		end
		ary
	end

	#
	# Returns an Array of Strings, which are this String object split into 32-byte
	# columns.
	#
	# When +ansi+ is either:
	#  * not given, or
	#  * given and false/nil
	# this method returns simple Strings.  Any other value for +ansi+
	# returns Strings including ANSI commands to alternate the background
	# of every four columns.
	#
	def wrap_printable ansi=false
		ary=[]
		if ansi
			g = false
			i = 0
			str=''
			scan(/.{1,4}/m).each do |c|
				if (g = !g)
					as = "\e[100m"
					ae = "\e[0m"
				else
					as = ae = ''
				end
				str << (as + c.printable + ae)
				if (i+=1)%8 == 0
					ary << str
					str = ''
				end
			end
			ary << str if str.length > 0
			ary.map{|s|"%-#{32 + s.scan(/\e\[(?:[0-9]+(?:;[0-9]+)*)m/).join.length}s"%s}
		else
			scan(/.{1,32}/m).each{|c|ary << ("%-32s" % c.printable)}
			ary
		end
	end

	#
	# Returns a copy of this String object, with all non-printable ASCII characters
	# replaced with +rep+ (default: ".")
	#
	def printable(rep=".") tr( ([*(0..31)] + [*(126..255)]).pack("C*"), rep[0..0] )  end

	#
	# Returns an Array of Strings, which are a combination of #wrap_hex and #wrap_printable.
	#
	# When +ansi+ is either:
	#  * not given, or
	#  * given and false/nil
	# this method returns simple Strings.  Any other value for +ansi+
	# returns Strings including ANSI commands to alternate the background
	# of every four columns in both hexy and sexy sections.
	#
	def hexdump(ansi=false)
		wrap_printable(ansi).zip(wrap_hex(ansi).map{|h|": #{h}"}).map{|e|e.join}
	end
end

