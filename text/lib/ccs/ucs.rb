# encoding: BINARY
# frozen_string_literal: true

require_relative '../ccs'

##
# Default Universal Character Set.
#
CCS::UCS = CCS.new(0, 0x10FFFF) do
  def valid? cp
    return false unless super
    return false if cp >= 0xD800 && cp <= 0xDFFF
    true
  end

  def render_codepoint cp
    'U+%04X' % cp
  end
end

##
# Strict Universal Character Set, that forbids non-character codepoints.
#
CCS::UCS_Strict = CCS.new(0, 0x10FFFF) do
  def valid? cp
    return false unless super
    return false if cp >= 0xD800 && cp <= 0xDFFF
    return false if cp >= 0xFDD0 && cp <= 0xFDEF
    return false if (cp & 0xFFFE) == 0xFFFE
    true
  end

  def render_codepoint cp
    'U+%04X' % cp
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
