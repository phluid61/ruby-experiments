# encoding: BINARY
# frozen_string_literal: true

require_relative '../ccs'

##
# ISO-8859-1.
#
CCS::ISO8859_1 = CCS.new('ISO-8859-1', 0, 255) do
  def render_codepoint cp
    return super(cp) unless valid? cp
    '\\x%02X' % cp
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
