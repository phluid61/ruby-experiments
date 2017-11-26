# encoding: BINARY
# frozen_string_literal: true

require_relative '../ccs'

##
# 7-bit US-ASCII
#
CCS::ASCII = CCS.new(0, 127) do
  def render_codepoint cp
    return super(cp) unless valid? cp
    '\\x%02X' % cp
  end
end

# vim: ts=2:sts=2:sw=2:expandtab