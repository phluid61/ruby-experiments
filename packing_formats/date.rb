
def cksum packed
	mask = 0x1C00_0000_0000_0000
	offs = 58
	sum = (packed & 0x8000_0000_0000_0000) >> 63
	while mask > 0x38
		sum ^= (packed & mask) >> offs
		offs -= 1
		mask >>= 1
	end
	sum
end

def pack_long_datetime year, month, day, hour, minute, second, usecond
	if year < 0
		year = -year
		bc = 1
	else
		bc = 0
	end
	if hour > 12
		hour -= 12
		pm = 1
	else
		pm = 0
	end
	packed = 0
	packed |= bc << 64
	packed |= (year & 0x3FFF) << 49
	packed |= (month & 0xF) << 45
	packed |= (day & 0x1F) << 40
	packed |= pm << 39
	packed |= (hour & 0xF) << 35
	packed |= (minute & 0x3F) << 29
	packed |= (second & 0x3F) << 23
	packed |= (usecond & 0xFFFFF) << 3
	packed | cksum(packed)
end

def unpack_long_datetime packed
	raise "Invalid checksum" unless (packed & 7) == cksum(packed)
	bc     =  packed & 0b10000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000
	year   = (packed & 0b01111111_11111110_00000000_00000000_00000000_00000000_00000000_00000000) >> 49
	month  = (packed & 0b00000000_00000001_11100000_00000000_00000000_00000000_00000000_00000000) >> 45
	day    = (packed & 0b00000000_00000000_00011111_00000000_00000000_00000000_00000000_00000000) >> 40
	pm     =  packed & 0b00000000_00000000_00000000_10000000_00000000_00000000_00000000_00000000
	hour   = (packed & 0b00000000_00000000_00000000_01111000_00000000_00000000_00000000_00000000) >> 35
	minute = (packed & 0b00000000_00000000_00000000_00000111_11100000_00000000_00000000_00000000) >> 29
	second = (packed & 0b00000000_00000000_00000000_00000000_00011111_10000000_00000000_00000000) >> 23
	usecond= (packed & 0b00000000_00000000_00000000_00000000_00000000_01111111_11111111_11111000) >>  3

	year = -year if bc != 0
	hour += 12 if pm != 0

	[year,month,day,hour,minute,second,usecond]
end

def time_to_long_datetime t
	pack_long_datetime t.year, t.month, t.day, t.hour, t.min, t.sec, t.nsec/1000
end

def long_datetime_to_time packed
	year,month,day,hour,minute,second,usecond = unpack_long_datetime packed
	Time.new year, month, day, hour, minute, Rational(second*1000000+usecond,1000000)
end

def pack_short_datetime year, month, day, hour, minute, second
	raise "Year out of bounds (1984..2047)" unless (1984..2047).include? year
	year -= 1984
	if hour > 12
		hour -= 12
		pm = 1
	else
		pm = 0
	end
	packed = 0
	packed |= year << 26
	packed |= (month & 0xF) << 22
	packed |= (day & 0x1F) << 17
	packed |= pm << 16
	packed |= (hour & 0xF) << 12
	packed |= (minute & 0x3F) << 6
	packed |= (second & 0x3F)
	packed
end

def unpack_short_datetime packed
	year   = (packed & 0b11111100_00000000_00000000_00000000) >> 26 + 1984
	month  = (packed & 0b00000011_11000000_00000000_00000000) >> 22
	day    = (packed & 0b00000000_00111110_00000000_00000000) >> 17
	pm     =  packed & 0b00000000_00000001_00000000_00000000
	hour   = (packed & 0b00000000_00000000_11110000_00000000) >> 12
	minute = (packed & 0b00000000_00000000_00001111_11000000) >> 6
	second =  packed & 0b00000000_00000000_00000000_00111111

	hour += 12 if pm != 0

	[year,month,day,hour,minute,second]
end

def time_to_short_datetime t
	pack_short_datetime t.year, t.month, t.day, t.hour, t.min, t.sec
end

def short_datetime_to_time packed
	year,month,day,hour,minute,second = unpack_short_datetime packed
	Time.new year, month, day, hour, minute, second
end

def pack_short_date year, month, day
	raise "Year out of bounds (1984..2047)" unless (1984..2047).include? year
	year -= 1984
	(year << 9) | ((month & 0xF) << 5) | (day & 0x3F)
end

def unpack_short_date packed
	year  = (packed & 0b11111110_00000000) >> 9 + 1984
	month = (packed & 0b00000001_11100000) >> 5
	day   =  packed & 0b00000000_00011111

	[year,month,day]
end

def time_to_short_date t
	pack_short_date t.year, t.month, t.day
end

def short_date_to_time packed
	year,month,day = unpack_short_date packed
	Time.new year, month, day
end

