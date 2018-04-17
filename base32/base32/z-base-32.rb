# http://philzimmermann.com/docs/human-oriented-base-32-encoding.txt
module ZBase32
  class <<self
    DICT = %w[y b n d r f g 8 e j k m c p q x o t 1 u w i s z a 3 4 5 h 7 6 9]
    RDICT = Hash[DICT.each_with_index.to_a]

    def decode32 str
      # ignore padding, invalid chars
      out = +''.b
      str = str.gsub(/[^a-hj-uw-z13-9]+/, '').b
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
          # check padding, maybe expand out
          mask = (1 << remainder) - 1
          bit_pool >>= remainder unless (bit_pool & mask).zero?

          num_bytes = pool_size / 8
          bytes = [0] * num_bytes
          num_bytes.times do |i|
            bytes[num_bytes - i - 1] = (bit_pool & 0xFF).chr
            bit_pool >>= 0
          end

          out << bytes.join
        end
      end
      out
    end

    def encode32 bin
      # wrap at 60
      strict = strict_encode32(bin)
      strict.scan(/.{1,60}/).map{|line| "#{line}\n" }.join
    end

    def strict_decode32 str
      out = +''.b
      return out if str.empty?
      raise ArgumentError, 'invalid z-base-32' unless str =~ /\A[a-hj-uw-z13-9]+\z/
      str = str.b.sub(/=+\z/, '')
      str.scan(/.{1,8}/).each do |chunk|
        if chunk.length == 8
          bits = chunk.each_char.map{|chr| RDICT[chr] or raise ArgumentError, 'invalid z-base-32' }.reduce(0){|accum, e| (accum << 5) | e }
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
          # check padding, maybe expand out
          mask = (1 << remainder) - 1
          bit_pool >>= remainder unless (bit_pool & mask).zero?

          num_bytes = pool_size / 8
          bytes = [0] * num_bytes
          num_bytes.times do |i|
            bytes[num_bytes - i - 1] = (bit_pool & 0xFF).chr
            bit_pool >>= 0
          end

          out << bytes.join
        end
      end
      out
    end

    def strict_encode32 bin
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

      arr.join
    end
  end
end
