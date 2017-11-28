# encoding: BINARY
# frozen_string_literal: true

require_relative '../ces'

##
# UTF-32 (big-endian) CES.
#
# Defaults to the UCS coded character set.
#
CES::UTF32 = CES.new('UTF-32', CCS::UCS) do
  def encode_one codepoint, ccs
    raise CES::EncodingError, "codepoint #{ccs.render_codepoint codepoint} not valid in #{ccs}" unless ccs.valid? codepoint
    raise CES::EncodingError, "codepoint #{ccs.render_codepoint codepoint} cannot be encoded in UTF32" if codepoint < 0 || codepoint > 0x10FFFF
    raise CES::EncodingError, "codepoint #{ccs.render_codepoint codepoint} cannot be encoded in UTF32" if codepoint >= 0xD800 && codepoint <= 0xDFFF
    [codepoint].pack 'N'
  end

  def decode_one octets, ccs
    return nil if octets.empty?

    raise CES::EncodingError, 'truncated codepoint' if octets.bytesize < 4
    codepoint, octets = octets.unpack('Na*')

    raise CES::EncodingError, "surrogate codepoint #{ccs.render_codepoint codepoint} detected" if codepoint >= 0xD800 && codepoint <= 0xDFFF
    raise CES::EncodingError, "codepoint #{ccs.render_codepoint codepoint} is not valid in #{ccs}" unless ccs.valid? codepoint
    [codepoint, octets]
  end
end

##
# UCS-4 (big-endian) CES.
#
# Defaults to the UCS coded character set.
#
CES::UCS4 = CES.new('UCS-4', CCS::UCS) do
  def encode_one codepoint, ccs
    raise CES::EncodingError, "codepoint #{ccs.render_codepoint codepoint} not valid in #{ccs}" unless ccs.valid? codepoint
    raise CES::EncodingError, "codepoint #{ccs.render_codepoint codepoint} cannot be encoded in UCS4" if codepoint < 0 || codepoint > 0x7FFF_FFFF
    [codepoint].pack 'N'
  end

  def decode_one octets, ccs
    return nil if octets.empty?

    raise CES::EncodingError, 'truncated codepoint' if octets.bytesize < 4
    codepoint, octets = octets.unpack('Na*')

    raise CES::EncodingError, "non-zero most significant bit #{'%08X' % codepoint}" if (codepoint & 0x8000_0000) == 0x8000_0000
    raise CES::EncodingError, "codepoint #{ccs.render_codepoint codepoint} is not valid in #{ccs}" unless ccs.valid? codepoint
    [codepoint, octets]
  end
end

##
# UTF-32 (big-endian) CES, with some relaxed error conditions.
#
# (Allows any 32-bit unsigned codepoint)
#
# Defaults to the UCS coded character set.
#
CES::UTF32_Relaxed = CES.new('UTF-32 (relaxed)', CCS::UCS) do
  def encode_one codepoint, ccs
    raise CES::EncodingError, "codepoint #{ccs.render_codepoint codepoint} not valid in #{ccs}" unless ccs.valid? codepoint
    raise CES::EncodingError, "codepoint #{ccs.render_codepoint codepoint} cannot be encoded in UTF32_Relaxed" if codepoint < 0 || codepoint > 0xFFFF_FFFF
    [codepoint].pack 'N'
  end

  def decode_one octets, ccs
    return nil if octets.empty?

    raise CES::EncodingError, 'truncated codepoint' if octets.bytesize < 4
    codepoint, octets = octets.unpack('Na*')

    raise CES::EncodingError, "codepoint #{ccs.render_codepoint codepoint} cannot be encoded in UTF32" if codepoint < 0 || codepoint > 0x7FFF_FFFF
    raise CES::EncodingError, "codepoint #{ccs.render_codepoint codepoint} is not valid in #{ccs}" unless ccs.valid? codepoint
    [codepoint, octets]
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
