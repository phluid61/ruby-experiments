# encoding: BINARY
# frozen_string_literal: true

require_relative '../ces'

##
# UTF-16 (big-endian) CES
#
# Defaults to the UCS coded character set.
#
CES::UTF16 = CES.new('UTF-16', CCS::UCS) do
  def encode_one codepoint, ccs
    ccs.assert_valid codepoint

    if (codepoint >= 0 && codepoint <= 0xD7FF) || (codepoint >= 0xE000 && codepoint <= 0xFFFF)
      [codepoint].pack 'n'
    elsif codepoint >= 0x10000 && codepoint <= 0x10FFFF
      codepoint -= 0x10000
      [(codepoint >> 10) + 0xD800, (codepoint & 0x3FF) + 0xDC00].pack 'nn'
    else
      raise Text::UnencodableCodepoint, "codepoint #{ccs.render_codepoint codepoint} cannot be encoded in #{name}"
    end
  end

  def decode_one octets, ccs
    return nil if octets.empty?

    raise Text::EncodingError, 'truncated codepoint' if octets.bytesize == 1

    first, octets = octets.unpack('na*')

    # If it's self-contained, return it as-is
    return [first, octets] if first <= 0xD7FF || first >= 0xE000

    # If it's not a high surrogate, it's bad
    raise Text::EncodingError, "unexpected low/trailing surrogate #{'%04X' % first}" unless first >= 0xD800 && first <= 0xDBFF

    # At this point, we need to find the second half of the surrogate pair.
    # First check for truncation...
    raise Text::EncodingError, 'high/leading surrogate without low/trailing pair' if octets.empty?
    raise Text::EncodingError, 'truncated codepoint' if octets.bytesize == 1

    second, octets = octets.unpack('na*')
    raise Text::EncodingError, "invalid low/trailing surrogate #{'%04X' % second}" unless second >= 0xDC00 && second <= 0xDFFF

    codepoint = ((first & 0x3FF) << 10) | (second & 0x3FF)
    ccs.assert_valid codepoint

    [codepoint, octets]
  end
end

##
# UCS-2 (big-endian) CES.
#
# Defaults to the UCS coded character set.
#
CES::UCS2 = CES.new('UCS-2', CCS::UCS) do
  def encode_one codepoint, ccs
    ccs.assert_valid codepoint
    raise Text::UnencodableCodepoint, "codepoint #{ccs.render_codepoint codepoint} cannot be encoded in #{name}" if codepoint < 0 || codepoint > 0xFFFF

    [codepoint].pack 'n'
  end

  def decode_one octets, ccs
    return nil if octets.empty?

    raise Text::EncodingError, 'truncated codepoint' if octets.bytesize == 1
    codepoint, octets = octets.unpack('na*')

    ccs.assert_valid codepoint
    [codepoint, octets]
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
