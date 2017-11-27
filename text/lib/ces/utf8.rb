# encoding: BINARY
# frozen_string_literal: true

require_relative '../ces'

##
# UTF-8 CES
#
# Defaults to the UCS coded character set.
#
# FIXME: doesn't detect surrogates
#
CES::UTF8 = CES.new('UTF-8', CCS::UCS) do
  def encode_one codepoint, ccs
    raise CES::EncodingError, "codepoint #{codepoint} not valid in #{ccs}" unless ccs.valid? codepoint

    if codepoint >= 0 && codepoint <= 0x7F
      [codepoint].pack 'C'
    elsif codepoint <= 0x10FFFF
      octets = []
      first_max  = 0b01111111
      first_mask = 0b00000000
      while codepoint > first_max
        octets << ((codepoint & 0b00111111) | 0x80)
        codepoint >>= 6
        first_mask = (first_mask >> 1) | 0xC0
        first_max = (0xFF ^ first_mask) >> 1
      end
      octets << (codepoint | first_mask)

      octets.reverse.pack 'C*'
    else
      raise CES::EncodingError, "codepoint #{codepoint} cannot be encoded in UTF8"
    end
  end

  def decode_one octets, ccs
    return nil if octets.empty?

    first, octets = octets.unpack('Ca*')
    if first <= 0x7F
      raise CES::EncodingError, "codepoint #{codepoint} is not valid in #{ccs}" unless ccs.valid? first
      return [first, octets]
    end

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
      raise CES::EncodingError, "\\x#{'%02X' % first} is not a valid initial octet in UTF8"
    end

    num.times do
      raise CES::EncodingError, 'truncated codepoint' if octets.empty?

      oct, octets = octets.unpack('Ca*')
      if (oct & 0b1100_0000) == 0b1000_0000
        part = oct & 0b0011_1111
        raise CES::EncodingError, 'overlong encoding detected' if part == 0
        codepoint = (codepoint << 6) | part
      else
        raise CES::EncodingError, "\\x#{'%02X' % first} is not a valid continuation octet in UTF8"
      end
    end

    raise CES::EncodingError, "codepoint #{codepoint} is not valid in #{ccs}" unless ccs.valid? codepoint

    [codepoint, octets]
  end
end

##
# UTF-8 CES, with some relaxed error conditions.
#
# Defaults to the UCS coded character set.
#
# TODO: override encode/decode to add optional 'replacement' param
#
CES::UTF8_Relaxed = CES.new('UTF-8 (relaxed)', CCS::UCS) do
  REPLACEMENT_CODEPOINT = 0xFFFD
  REPLACEMENT_OCTETS = "\xEF\xBF\xBD".freeze

  ##
  # @param +codepoint+
  # @param +ccs+
  # @param +replacement+ octet sequence to substitute for a bad codepoint
  #
  def encode_one codepoint, ccs, replacement=REPLACEMENT_OCTETS
    return replacement unless ccs.valid? codepoint

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
      raise CES::EncodingError, "codepoint #{codepoint} cannot be encoded in UTF8_Relaxed"
    end
  end

  ##
  # @param +octets+
  # @param +ccs+
  # @param +replacement+ fallback codepoint for bad data. Not validated against +ccs+
  #
  def decode_one octets, ccs, replacement=REPLACEMENT_CODEPOINT
    return nil if octets.empty?

    #replacement = replacement.serialize(self, ccs) if replacement.respond_to? :serialize
    replacement = replacement.each_char.map {|c| break c.ord } if replacement.respond_to? :each_char

    first, octets = octets.unpack('Ca*')
    if first <= 0x7F
      return [replacement, octets] unless ccs.valid? first
      return [first, octets]
    end

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
      return [replacement, octets]
    end

    # On error, convert the first byte of an invalid sequence to U+FFFD,
    # and continue parsing with the next byte.  So we have to remember
    # what that next byte (and everything after it) actually were.
    fallback_octets = octets

    num.times do
      return [replacement, nil] if octets.empty?

      oct, octets = octets.unpack('Ca*')
      if (oct & 0b1100_0000) == 0b1000_0000
        part = oct & 0b0011_1111
        # Note: we allow overlong encodings
        codepoint = (codepoint << 6) | part
      else
        return [replacement, fallback_octets]
      end
    end

    return [replacement, fallback_octets] unless ccs.valid? codepoint

    [codepoint, octets]
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
