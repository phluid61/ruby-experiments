class KTime
  SECONDS_PER_TIC = Rational(1318359375, 1000000000)
  #TICS_PER_SECOND = 0.758518518518518#...

  EPOCH_DAY_OF_GREGORIAN_YEAR = 297
  EPOCH_DAY_OF_GREGORIAN_LEAP_YEAR = 298
  GREGORIAN_DAYS_AFTER_EPOCH  = 68

  MONTH_NAMES = %w{ ProphetsDay Antepod Macropod Phennel Mujuss Rastor Gimbol Fredegar Whipple Spink Jambo Wombley Flank Runcible }
  MONTH_NAMES_ABBR = %w{ XXX Ant Mac Phe Muk Ras Gim Fre Whi Spi Jam Wom Fla Run }

  def KTime.now
    KTime.new
  end

  def KTime.at time
    KTime.new time
  end

  def initialize t=nil
    @t = t ? Time.at(t) : Time.now

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

    leap_year = (y % 4 == 0) and ((y % 100 > 0) or (y % 400 == 0))

    if leap_year
      if (m < 10) || (m == 10 && d < 23)
        # it is before DOT, so last year
        # 1980 => -1
        # 1981 => 0
        @year = y - 1981
        @doy = yday + GREGORIAN_DAYS_AFTER_EPOCH
        @month = (@doy - 1) / 28 + 1
        @day = (@doy - 1) % 28 + 1
      elsif m == 10 && (d == 23 || d == 24)
        # the blessed day
        # 1980 => 0
        # 1981 => 1
        @year = y - 1980
        @doy = 0
        @month = 0
        @day = d - 23
      else
        # it is after DOT, so this year
        # 1980 => 0
        # 1981 => 1
        @year = y - 1980
        @doy = yday - EPOCH_DAY_OF_GREGORIAN_LEAP_YEAR
        @month = (@doy - 1) / 28 + 1
        @day = (@doy - 1) % 28 + 1
      end
    else
      if (m < 10) || (m == 10 && d < 24)
        # it is before DOT, so last year
        # 1980 => -1
        # 1981 => 0
        @year = y - 1981
        @doy = yday + GREGORIAN_DAYS_AFTER_EPOCH
        @month = (@doy - 1) / 28 + 1
        @day = (@doy - 1) % 28 + 1
      elsif m == 10 && d == 24
        # the blessed day
        # 1980 => 0
        # 1981 => 1
        @year = y - 1980
        @doy = 0
        @month = 0
        @day = 1
      else
        # it is after DOT, so this year
        # 1980 => 0
        # 1981 => 1
        @year = y - 1980
        @doy = yday - EPOCH_DAY_OF_GREGORIAN_YEAR
        @month = (@doy - 1) / 28 + 1
        @day = (@doy - 1) % 28 + 1
      end
    end
  end

  def to_s
    '%3s %3s %2d %X%X%X%X %+05d %04d' % ['???', MONTH_NAMES_ABBR[@month], @day, @match, @egg, @ad, @tic, 0, @year]
  end

  attr_reader :doy
end

if $0 == __FILE__
#  k = KTime.now
#  p k
#  p k.to_s
#
#  t = Time.now
#  p t.to_s
#
#  puts '---'

  prev = nil
  time = Time.mktime(1979,10,23,1,2,3,45)
#  20.times do
  (365+366+3).times do
    k = KTime.at time
    if prev.nil? || (prev+1) == k.doy
      puts "#{k.to_s.inspect}  #{k.inspect}"
    else
      puts "\e[31m#{k.to_s.inspect}  #{k.inspect}\e[0m"
    end
    prev = k.doy
    time = time + 86400
  end

#  puts '---'
#  (1..12).each do |m|
#    time = Time.mktime(1981,m,20,1,2,3,45)
#    k = KTime.at time
#    puts k
#  end
end

