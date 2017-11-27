# encoding: BINARY
# frozen_string_literal: true

require_relative 'serialization'
require_relative 'ces'
require_relative 'ccs'

##
# A thought experiment made real.
#
class Text
  def self.from_ruby_string str
    if str.valid_encoding?
      str = str.encode(Encoding::UTF_8)
      #ces = CES::UTF8
      ces = CES::UTF8_Relaxed
      ccs = ces.default_ccs
    else
      # close enough...
      str = str.force_encoding(Encoding::ASCII_8BIT)
      ces = CES::SBCS
      ccs = CCS::WINDOWS1252
    end
    codepoints = ces.decode str, ccs
    self.new codepoints, ccs
  end

  def initialize codepoints, ccs
    codepoints = codepoints.to_a unless codepoints.is_a? Array # not to_ary
    codepoints = codepoints.dup.freeze unless codepoints.frozen?

    @codepoints = codepoints
    @length = codepoints.length
    @chars = nil
    @ccs = ccs
  end
  attr_reader :length, :ccs

  def inspect
    "\#<Text #{@length}:[#{@codepoints.map{|cp| '%04X' % cp }.join(',')}] #{@ccs.inspect}>"
  end

  def to_a
    @codepoints
  end

  def to_ruby_string
    transcode_and_serialize.to_s
  end
  alias to_s to_ruby_string

  def each_codepoint &block
    @codepoints.each(&block)
  end
  alias each each_codepoint

  def transcode_and_serialize ces=CES::UTF8, ccs=nil
    ces.encode ces.transcode(@codepoints, @ccs, ccs), ccs
  end

  def serialize ces=CES::UTF8, ccs=nil
    ces.encode @codepoints, ccs
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
