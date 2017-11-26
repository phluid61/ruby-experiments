# encoding: BINARY
# frozen_string_literal: true

require_relative '../ces'

##
# UTF-16 (big-endian) CES
#
# Defaults to the UCS coded character set.
#
CES::UTF16 = CES.new(CCS::UCS) do
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

    raise ArgumentError, 'truncated codepoint' if octets.bytesize == 1

    first, octets = octets.unpack('na*')

    # If it's self-contained, return it as-is
    return [first, octets] if first <= 0xD7FF || first >= 0xE000

    # If it's not a high surrogate, it's bad
    raise ArgumentError, "unexpected low/trailing surrogate #{'%04X' % first}" unless first >= 0xD800 && first <= 0xDBFF

    # At this point, we need to find the second half of the surrogate pair.
    # First check for truncation...
    raise ArgumentError, 'high/leading surrogate without low/trailing pair' if octets.empty?
    raise ArgumentError, 'truncated codepoint' if octets.bytesize == 1

    second, octets = octets.unpack('na*')
    raise ArgumentError, "invalid low/trailing surrogate #{'%04X' % second}" unless second >= 0xDC00 && second <= 0xDFFF

    codepoint = ((first & 0x3FF) << 10) | (second & 0x3FF)
    raise ArgumentError, "codepoint #{codepoint} is not valid in #{ccs}" unless ccs.valid? codepoint

    [codepoint, octets]
  end
end

##
# UCS-2 (big-endian) CES.
#
# Defaults to the UCS coded character set.
#
CES::UCS2 = CES.new(CCS::UCS) do
  def encode_one codepoint, ccs
    raise ArgumentError, "codepoint #{codepoint} not valid in #{ccs}" unless ccs.valid? codepoint
    raise ArgumentError, "codepoint #{codepoint} cannot be encoded in UCS2" if codepoint < 0 || codepoint > 0xFFFF

    [codepoint].pack 'n'
  end

  def decode_one octets, ccs
    return nil if octets.empty?

    raise ArgumentError, 'truncated codepoint' if octets.bytesize == 1
    codepoint, octets = octets.unpack('na*')

    raise ArgumentError, "codepoint #{codepoint} is not valid in #{ccs}" unless ccs.valid? codepoint
    [codepoint, octets]
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
