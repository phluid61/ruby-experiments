
module Numeral
  class Parser
    def initialize buffer, stop_on_invalid=true
      @buffer = buffer.to_s.downcase
      @invalid = !stop_on_invalid
      @value = nil
    end

    def value
      @value = _parse unless @value
      @value
    end

    def rest
      @value = _parse unless @value
      @buffer.dup
    end

  private

    MAP = {
      "\u2188" => 100_000,
      "\u2187" => 50_000,
      "\u2186" => 50,
      "\u2185" => 6,
      #"\u2184" => nil,
      "\u2183" => 100,
      "\u2182" => 10_000,
      "\u2181" => 5000,
      "\u2180" => 1000,
      "\u217F" => 1000, 'm' => 1000,
      "\u217E" =>  500, 'd' =>  500,
      "\u217D" =>  100, 'c' =>  100,
      "\u217C" =>   50, 'l' =>   50,
      "\u217B" =>   12,
      "\u217A" =>   11,
      "\u2179" =>   10, 'x' =>   10,
      "\u2178" =>    9,
      "\u2177" =>    8,
      "\u2176" =>    7,
      "\u2175" =>    6,
      "\u2174" =>    5, 'v' =>    5,
      "\u2173" =>    4,
      "\u2172" =>    3,
      "\u2171" =>    2,
      "\u2170" =>    1, 'i' =>    1,

      "\u{10320}" => 1,
      "\u{10321}" => 5,
      "\u{10322}" => 10,
      "\u{10323}" => 50,
    }

    def _next_seq
      return nil if @buffer.empty?
      if @buffer.sub! /\A((.)\2*)/u, ''
        a = MAP[$2]
        if a || @invalid
          [a, $1.length]
        else
          @buffer = "#{$1}#{@buffer}"
          nil
        end
      else
        raise 'bug'
      end
    end

    # TODO: allow final 'j' swash?
    def _parse
      accum = 0

      last_digit = nil
      last_count = 0

      while seq = _next_seq
        this_digit, this_count = seq

        next if this_digit.nil? && @invalid
        raise 'bug' if this_digit.nil?

        if last_digit.nil?
          last_digit, last_count = this_digit, this_count
        elsif this_digit > last_digit
          accum += (last_digit * (last_count - 1))
          accum += (this_digit - last_digit)
          if this_count > 1
            last_digit, last_count = this_digit, (this_count - 1)
          else
            last_digit = nil
          end
        else
          accum += (last_digit * last_count)
          last_digit, last_count = this_digit, this_count
        end
      end

      if last_digit
        accum += (last_digit * last_count)
      end

      accum
    end
  end

  class Stringifier
    def initialize num
      @num = num.to_i
    end

    ASCII_MAP = [
      ['M', 1000],
      ['CM', 900],
      ['D', 500],
      ['C', 100],
      ['XC', 90],
      ['L', 50],
      ['X', 10],
      ['IX', 9],
      ['V', 5],
      ['IV', 4],
      ['I', 1],
    ]

    ASCII_MAP_NOSUB = [
      ['M', 1000],
      ['D', 500],
      ['C', 100],
      ['L', 50],
      ['X', 10],
      ['V', 5],
      ['I', 1],
    ]

    CLOCKFACE_MAP = [
      ['X', 10],
      ['IX', 9],
      ['V', 5],
      ['I', 1],
    ]

    def ascii subtractive: true, lowercase: false, swash: false
      str = _map(subtractive ? ASCII_MAP : ASCII_MAP_NOSUB)
      if lowercase || swash
        str = str.downcase
        str.sub! /i\z/, 'j' if swash
      end
      str
    end

    # Use on values outside 1..12 is undefined.
    def clockface lowercase: false
      str = _map CLOCKFACE_MAP
      str = str.downcase if lowercase
      str
    end

  private

    def _map map
      str = +''
      rem = @num
      map.each do |symbol, value|
        count, rem = rem.divmod value
        str << (symbol * count) if count > 0
      end
      str
    end
  end
end

