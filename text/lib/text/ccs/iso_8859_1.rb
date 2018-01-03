# encoding: BINARY
# frozen_string_literal: true

require_relative '../ccs'

##
# ISO-8859-1 Latin alphabet No. 1
#
CCS::ISO_8859_1 = CCS.new('ISO-8859-1', 0, 255) do
  def render_codepoint cp
    return super(cp) unless valid? cp
    '\\x%02X' % cp
  end
end

CCS::LATIN_1       = CCS::ISO_8859_1
CCS::CP819         = CCS::ISO_8859_1
CCS::WINDOWS_28591 = CCS::ISO_8859_1

CCS::WesternEuropean = CCS::ISO_8859_1

##
# ISO-8859-1, strict mode (no control characters)
#
CCS::ISO_8859_1_Strict = CCS.new('ISO-8859-1 (strict)', 0x20, 0xFF) do
  def valid? cp
    (cp >= 0x20 && cp <= 0x7E) || (cp >= 0xA0 && cp <= 0xFF)
  end

  def render_codepoint cp
    return super(cp) unless valid? cp
    '\\x%02X' % cp
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
