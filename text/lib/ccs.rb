# encoding: BINARY
# frozen_string_literal: true

##
# Coded character set (maps logical 'characters' to tangible 'codepoints').
#
# You can think of this like a character repertoire, but that's not
# technically accurate.
#
class CCS
  def initialize min, max, &block
    @min = min
    @max = max
    instance_eval(&block) if block_given?
  end

  def valid? cp
    cp >= min && cp <= max
  end

  # Maps a codepoint to its UCS value.
  def to_ucs cp
    raise "invalid codepoint #{render_codepoint cp}" unless valid? cp
    # the default implementation works for any fully UCS-compatible CCS
    cp
  end

  # Maps a UCS codepoint to its local value.
  def from_ucs cp
    raise "invalid codepoint #{render_codepoint cp}" unless valid? cp
    # the default implementation works for any fully UCS-compatible CCS
    cp
  end

  # This doesn't care about validity.
  def render_codepoint cp
    '[%04X]' % cp
  end
end

require_relative 'ccs/ucs'
require_relative 'ccs/ascii'
require_relative 'ccs/cp347'

# vim: ts=2:sts=2:sw=2:expandtab
