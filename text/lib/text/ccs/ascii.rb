# encoding: BINARY
# frozen_string_literal: true

require_relative '../ccs'

##
# 7-bit US-ASCII
#
CCS::US_ASCII = CCS.new('US-ASCII', 0, 127) do
  def render_codepoint cp
    return super(cp) unless valid? cp
    '\\x%02X' % cp
  end
end

CCS::ASCII = CCS::US_ASCII

# vim: ts=2:sts=2:sw=2:expandtab
