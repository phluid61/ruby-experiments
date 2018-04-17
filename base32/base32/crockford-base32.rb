# http://www.crockford.com/wrmg/base32.html
module CrockfordBase32
  class <<self
    DICT = %w[0 1 2 3 4 5 6 7 8 9 A B C D E F G H J K M N P Q R S T V W X Y Z]
    RDICT = Hash[DICT.each_with_index.to_a]

    CHECK = %w[* ~ $ = U]
    RCHECK = Hash[CHECK.each_with_index.to_a]

    def decode32 str
      # ignore padding, invalid chars
      out = +''.b
      return out if str.empty?
      return out if str == '*'
      str = str.b.upcase.gsub('-','').gsub('O','0').gsub(/[IL]/,'1')
      str = str.gsub(/[^0-9A-HJKMNP-TV-Z]+[*~$=U]?/, '')

      if str.sub!(/([*~$=U])\Z/, '')
        checksum = RCHECK[$1]
      else
        checksum = nil
      end

      str.scan(/.{1,8}/).each do |chunk|
        if chunk.length == 8
          bits = chunk.each_char.map{|chr| RDICT[chr] }.reduce(0){|accum, e| (accum << 5) | e }
          out << [bits].pack('Q>')[-5..-1]
        else
          bit_pool = 0
          pool_size = 0

          chunk.each_char do |chr|
            pentet = RDICT[chr]

            bit_pool = (bit_pool << 5) | pentet
            pool_size += 5
          end

          remainder = pool_size % 8
          #-- validate padding
          mask = (1 << remainder) - 1
          warn 'detected non-zero padding bits in base32 data' unless (bit_pool & mask).zero?
          #--
          bit_pool >>= remainder

          num_bytes = pool_size / 8
          bytes = [0] * num_bytes
          num_bytes.times do |i|
            bytes[num_bytes - i - 1] = (bit_pool & 0xFF).chr
            bit_pool >>= 0
          end

          out << bytes.join
        end
      end

      if checksum
        checkvalue = out.each_byte.reduce(0){|sum, byte| (sum + byte) % 37 }
        raise ArgumentError, "bad checksum in crockford-base32 data (got #{checkvalue}, expected #{checksum})" if checkvalue != checksum
      end

      out
    end

    def encode32 bin, checksum=false
      # insert hyphens every 8 characters
      strict = strict_encode32(bin, checksum)
      strict.scan(/.{1,8}/).join('-')
    end

    def strict_decode32 str
      out = +''.b
      return out if str.empty?
      return out if str == '*'
      str = str.b.upcase.gsub('-','').gsub('O','0').gsub(/[IL]/,'1')
      str = str.gsub(/[^0-9A-HJKMNP-TV-Z]+[*~$=U]?/, '')
      raise ArgumentError, 'invalid crockford-base32' unless str =~ /\A[0-9A-HJKMNP-TV-Z]+[*~$=U]?\z/

      if str.sub!(/([*~$=U])\Z/, '')
        checksum = RCHECK[$1]
      else
        checksum = nil
      end

      str.scan(/.{1,8}/).each do |chunk|
        if chunk.length == 8
          bits = chunk.each_char.map{|chr| RDICT[chr] or raise ArgumentError, 'invalid crockford-base32' }.reduce(0){|accum, e| (accum << 5) | e }
          out << [bits].pack('Q>')[-5..-1]
        else
          bit_pool = 0
          pool_size = 0

          chunk.each_char do |chr|
            pentet = RDICT[chr]

            bit_pool = (bit_pool << 5) | pentet
            pool_size += 5
          end

          remainder = pool_size % 8
          #-- validate padding
          mask = (1 << remainder) - 1
          raise ArgumentError, 'invalid crockford-base32 (non-zero padding bits)' unless (bit_pool & mask).zero?
          #--
          bit_pool >>= remainder

          num_bytes = pool_size / 8
          bytes = [0] * num_bytes
          num_bytes.times do |i|
            bytes[num_bytes - i - 1] = (bit_pool & 0xFF).chr
            bit_pool >>= 0
          end

          out << bytes.join
        end
      end

      if checksum
        checkvalue = out.each_byte.reduce(0){|sum, byte| (sum + byte) % 37 }
        raise ArgumentError, "bad checksum in crockford-base32 data (got #{checkvalue}, expected #{checksum})" if checkvalue != checksum
      end

      out
    end

    def strict_encode32 bin, checksum=false
      arr = []

      bit_pool = 0
      pool_size = 0

      bytes = bin.bytes
      loop do
        while pool_size >= 5
          shift = pool_size - 5
          pentet = bit_pool >> shift
          arr << DICT[pentet]

          bit_pool &= ((1 << shift) - 1)
          pool_size = shift
        end
        if bytes.empty?
          break if pool_size == 0

          shift = 5 - pool_size
          pool_size = 5
          bit_pool <<= shift
        else
          bit_pool = (bit_pool << 8) | bytes.shift
          pool_size += 8
        end
      end

      if checksum
        checkvalue = bin.bytes.reduce(0){|sum, byte| (sum + byte) % 37 }
        arr << CHECK[checkvalue]
      end

      arr.join
    end
  end
end
