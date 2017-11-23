# encoding: UTF-8
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
    @codepoints = []
  end
  attr_reader :length

  def each &block
    @codepoints.each(&block)
  end
  alias each_char each

  def serialize ces=CES::UTF8, ccs=nil
    ces.encode @codepoints, ccs
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
