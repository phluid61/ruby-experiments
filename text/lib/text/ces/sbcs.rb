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
    ccs.assert_valid codepoint
    raise UnencodableCodepoint, "codepoint #{ccs.render_codepoint codepoint} cannot be encoded in #{name}" unless codepoint >= 0 && codepoint <= 0xFF
    [codepoint].pack 'C'
  end

  def decode_one octets, ccs
    return nil if octets.empty?
    codepoint, octets = octets.unpack('Ca*')
    ccs.assert_valid codepoint
    [codepoint, octets]
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
