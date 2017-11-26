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
CES::UTF8 = CES.new(CCS::UCS) do
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
      raise ArgumentError, 'truncated codepoint' if octets.empty?

      oct, octets = octets.unpack('Ca*')
      if (oct & 0b1100_0000) == 0b1000_0000
        part = oct & 0b0011_1111
        raise ArgumentError, 'overlong encoding detected' if part == 0
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
# Defaults to the UCS coded character set.
#
# TODO: override encode/decode to add optional 'replacement' param
#
CES::UTF8_Relaxed = CES.new(CCS::UCS) do
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
      raise ArgumentError, "codepoint #{codepoint} cannot be encoded in UTF8_Relaxed"
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
