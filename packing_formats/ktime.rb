class KTime
	SECONDS_PER_TIC = 1.318359375
	#TICS_PER_SECOND = 0.758518518518518#...

	EPOCH_DAY_OF_GREGORIAN_YEAR = 297 # plus one on leap years
	GREGORIAN_DAYS_AFTER_EPOCH  = 68

	MONTH_NAMES = %w{ Runcible Antepod Macropod Phennel Mujuss Rastor Gimbol Fredegar Whipple Spink Jambo Wombley Flank Runcible }
	MONTH_NAMES_ABBR = %w{ Run Ant Mac Phe Muk Ras Gim Fre Whi Spi Jam Wom Fla Run }

	def KTime.now
		KTime.new
	end

	def initialize
		@t = Time.now

		#
		# Time of Day
		#

		usec = (@t.hour * 3600 + @t.min * 60 + @t.sec) * 1_000_000 + @t.usec
		 sec = usec.to_f / 1_000_000.0

		tics = sec / SECONDS_PER_TIC

		@tic_of_day   = tics.to_i
		@ad_of_day    = @tic_of_day / 16
		@egg_of_day   = @ad_of_day  / 16
		@match_of_day = @egg_of_day / 16

		@utic = tics - @tic_of_day

		@tic = @tic_of_day   % 16
		@ad  = @ad_of_day    % 16
		@egg = @egg_of_day   % 16
		@match = @match_of_day % 16 # hah

		#
		# Date Stuff
		#

		y = @t.year
		m = @t.month
		d = @t.day

		yday = @t.yday

		x = y - 1
		leap_xear = (x % 4 == 0) and ((x % 100 > 0) or (x % 400 == 0))
		leap_year = (y % 4 == 0) and ((y % 100 > 0) or (y % 400 == 0))

		# Let's go against the Christian "no year 0" thing,
		# just to irritate people.
		if (m < 10) or (m == 10 and d < 24)
			# last year
#			@year = if y > 1980; y - 1980
#				else y - 1981
#				end
			@year = y - 1980

			# days since last dot?
			doy = yday + GREGORIAN_DAYS_AFTER_EPOCH

			@month = (doy / 28) + 1
			@day   = (doy % 28) + 1
		elsif m == 10 and d == 24
			# w00t
			@year  = y - 1980
			@month = 0
			@day   = 1
		elsif leap_year and m == 10 and d == 25
			# w00t
			@year  = y - 1980
			@month = 0
			@day   = 2
		else
			# next year
			@year = if y >= 1980; y - 1979
				else y - 1989
				end

			# days since dot?
			dot = EPOCH_DAY_OF_GREGORIAN_YEAR + (leap_year ? 1 : 0)
			doy = yday - dot

			@month = (doy / 28) + 1
			@day   = (doy % 28) + 1
		end

	end

	def to_s
		'%3s %3s %2d %X%X%X%X %+05d %04d' % ['???', MONTH_NAMES_ABBR[@month], @day, @match, @egg, @ad, @tic, 0, @year]
	end
end

if $0 == __FILE__
	k = KTime.now
	p k
	p k.to_s

	t = Time.now
	p t.to_s
end

