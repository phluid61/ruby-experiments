# encoding: BINARY
# frozen_string_literal: true

require_relative 'serialization'
require_relative 'ces'
require_relative 'ccs'

##
# A thought experiment made real.
#
class Text
  def initialize
    @length = 0
    @codepoints = [].freeze
    @chars = nil
    @serialization = nil
  end
  attr_reader :length

  def each_codepoint &block
    @codepoints.each(&block)
  end
  alias each each_codepoint

  def serialize ces=CES::UTF8, ccs=nil
    ces.encode @codepoints, ccs
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
