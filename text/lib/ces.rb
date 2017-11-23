# encoding: UTF-8
# frozen_string_literal: true

require_relative 'ccs'

##
# Character encoding scheme (maps integer codepoints to sequences of octets)
#
class CES
  def initialize default_ccs, &block
    @default_ccs = default_ccs
    instance_eval(&block) if block_given?
  end
  attr_reader :default_ccs

  ##
  # @return serialization
  def encode codepoints, ccs=nil
    ccs ||= default_ccs

    s = Serialization.new '', self, ccs
    codepoints.each do |cp|
      s << encode_one(cp, ccs)
    end
    s
  end

  ##
  # @return [codepoints...]
  def decode octets, ccs=nil
    octets = octets.to_str unless octets.is_a? String
    ccs ||= default_ccs

    codepoints = []
    while octets && !octets.empty?
      cp, octets = decode_one(octets, ccs)
      codepoints << cp
    end
    codepoints
  end

  ##
  # @return octets
  def encode_one codepoint, ccs
    raise NotImplementedError
  end

  ##
  # @return [codepoint, remainder|nil] or nil
  def decode_one octets, ccs
    raise NotImplementedError
  end

  ##
  # UTF-8 CES
  #
  # Defaults to the Unicode coded character set.
  #
  UTF8 = CES.new(CCS::Unicode) do
    def encode_one codepoint, ccs
      raise ArgumentError, "codepoint #{codepoint} not valid in #{ccs}" unless ccs.valid? codepoint

      if codepoint >= 0 && codepoint <= 0x7F
        [codepoint].pack 'C'
      elsif codepoint <= 0x10FFFF
        first_header = 0xc0
        octets = []
        while codepoint > 0x3f
          octets << ((codepoint & 0x3f) | 0x80)
          first_header = (first_header >> 1) | 0x80
        end
        octets << (codepoint | first_header)

        codepoints.reverse.pack 'C*'
      else
        raise ArgumentError, "codepoint #{codepoint} cannot be encoded in UTF8"
      end
    end

    def decode_one octets, ccs
      return nil if octets.empty?

      first, octets = octets.unpack('Ca*')
      return [first, octets] if first <= 0x7F

      if (first & 0b1110_0000) == 0b1100_0000
        codepoint = first & 0b0001_1111
        num = 1
      elsif (first & 0b1111_0000) == 0b1110_0000
        codepoint = first & 0b0000_1111
        num = 2
      elsif (first & 0b1111_1000) == 0b1111_0000
        codepoint = first & 0b0000_0111
        num = 3
      else
        raise ArgumentError, "\\x#{'%02X' % first} is not a valid initial octet in UTF8"
      end

      num.times do
        raise ArgumentError, 'Truncated codepoint' if octets.empty?

        oct, octets = octets.unpack('Ca*')
        if (oct & 0b1100_0000) == 0b1000_0000
          part = oct & 0b0011_1111
          raise ArgumentError, 'Overlong encoding detected' if part == 0
          codepoint = (codepoint << 6) | part
        else
          raise ArgumentError, "\\x#{'%02X' % first} is not a valid continuation octet in UTF8"
        end
      end

      raise ArgumentError, "codepoint #{codepoint} is not valid in #{ccs}" unless ccs.valid? codepoint

      [codepoint, octets]
    end
  end

  ##
  # UTF-8 CES, with some relaxed error conditions.
  #
  # Defaults to the Unicode coded character set.
  #
  UTF8_Relaxed = CES.new(CCS::Unicode) do
    REPLACEMENT_CODEPOINT = 0xFFFD
    REPLACEMENT_OCTETS = "\xEF\xBF\xBD".freeze

    def encode_one codepoint, ccs
      return REPLACEMENT_OCTETS unless ccs.valid? codepoint

      if codepoint >= 0 && codepoint <= 0x7F
        [codepoint].pack 'C'
      elsif codepoint <= 0x10FFFF
        first_header = 0xc0
        octets = []
        while codepoint > 0x3f
          octets << ((codepoint & 0x3f) | 0x80)
          first_header = (first_header >> 1) | 0x80
        end
        octets << (codepoint | first_header)

        octets.reverse.pack 'C*'
      else
        raise ArgumentError, "codepoint #{codepoint} cannot be encoded in UTF8"
      end
    end

    def decode_one octets, ccs
      return nil if octets.empty?

      first, octets = octets.unpack('Ca*')
      return [first, octets] if first <= 0x7F

      if (first & 0b1110_0000) == 0b1100_0000
        codepoint = first & 0b0001_1111
        num = 1
      elsif (first & 0b1111_0000) == 0b1110_0000
        codepoint = first & 0b0000_1111
        num = 2
      elsif (first & 0b1111_1000) == 0b1111_0000
        codepoint = first & 0b0000_0111
        num = 3
      else
        return [REPLACEMENT_CODEPOINT, octets]
      end

      # On error, convert the first byte of an invalid sequence to U+FFFD,
      # and continue parsing with the next byte.  So we have to remember
      # what that next byte (and everything after it) actually were.
      fallback_octets = octets

      num.times do
        return [REPLACEMENT_CODEPOINT, nil] if octets.empty?

        oct, octets = octets.unpack('Ca*')
        if (oct & 0b1100_0000) == 0b1000_0000
          part = oct & 0b0011_1111
          # Note: we allow overlong encodings
          codepoint = (codepoint << 6) | part
        else
          return [REPLACEMENT_CODEPOINT, fallback_octets]
        end
      end

      return [REPLACEMENT_CODEPOINT, fallback_octets] unless ccs.valid? codepoint

      [codepoint, octets]
    end
  end

  ##
  # UTF-16 (big-endian) CES
  #
  # Defaults to the Unicode coded character set.
  #
  UTF16 = CES.new(CCS::Unicode) do
    def encode_one codepoint, ccs
      raise ArgumentError, "codepoint #{codepoint} not valid in #{ccs}" unless ccs.valid? codepoint

      if (codepoint >= 0 && codepoint <= 0xD7FF) || (codepoint >= 0xE000 && codepoint <= 0xFFFF)
        [codepoint].pack 'n'
      elsif codepoint >= 0x10000 && codepoint <= 0x10FFFF
        codepoint -= 0x10000
        [(codepoint >> 10) + 0xD800, (codepoint & 0x3FF) + 0xDC00].pack 'nn'
      else
        raise ArgumentError, "codepoint #{codepoint} cannot be encoded in UTF16"
      end
    end

    def decode_one octets, ccs
      return nil if octets.empty?

      raise ArgumentError, 'Truncated codepoint' if octets.bytesize == 1

      first, octets = octets.unpack('na*')

      # If it's UCS-2, return it as-is
      return [first, octets] if first <= 0xD7FF || first >= 0xE000

      # If it's not a high surrogate, it's bad
      raise ArgumentError, "Unexpected low/trailing surrogate #{'%04X' % first}" unless first >= 0xD800 && first <= 0xDBFF

      # At this point, we need to find the second half of the surrogate pair.
      # First check for truncation...
      raise ArgumentError, 'High/leading surrogate without low/trailing pair' if octets.empty?
      raise ArgumentError, 'Truncated codepoint' if octets.bytesize == 1

      second, octets = octets.unpack('na*')
      raise ArgumentError, "Invalid low/trailing surrogate #{'%04X' % second}" unless second >= 0xDC00 && second <= 0xDFFF

      codepoint = ((first & 0x3FF) << 10) | (second & 0x3FF)
      raise ArgumentError, "codepoint #{codepoint} is not valid in #{ccs}" unless ccs.valid? codepoint

      [codepoint, octets]
    end
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
