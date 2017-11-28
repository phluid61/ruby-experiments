# encoding: BINARY
# frozen_string_literal: true

require_relative '../ces'

##
# Generic 'Single Byte Character Set' CES
#
# Defaults to the UCS coded character set.
#
CES::SBCS = CES.new('SBCS', CCS::UCS) do
  def encode_one codepoint, ccs
    raise CES::EncodingError, "codepoint #{ccs.render_codepoint codepoint} not valid in #{ccs}" unless ccs.valid? codepoint
    raise CES::EncodingError, "codepoint #{ccs.render_codepoint codepoint} cannot be encoded in UTF8" unless codepoint >= 0 && codepoint <= 0xFF
    [codepoint].pack 'C'
  end

  def decode_one octets, ccs
    return nil if octets.empty?
    codepoint, octets = octets.unpack('Ca*')
    raise CES::EncodingError, "codepoint #{ccs.render_codepoint codepoint} is not valid in #{ccs}" unless ccs.valid? codepoint
    [codepoint, octets]
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
