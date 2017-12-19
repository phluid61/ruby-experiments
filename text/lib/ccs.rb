# encoding: BINARY
# frozen_string_literal: true

##
# Coded character set (maps logical 'characters' to tangible 'codepoints').
#
# You can think of this like a character repertoire, but that's not
# technically accurate.
#
class CCS
  def self.instances
    (@@instances || []).dup
  end

  def self.each &block
    return enum_for(:each) unless block_given?
    (@@instances || []).each(&block)
  end

  def initialize name, min, max, &block
    @name = name.to_str.dup.freeze
    @min = min
    @max = max
    instance_eval(&block) if block_given?

    @@instances ||= []
    @@instances << self
  end
  attr_reader :name

  def inspect
    "\#<CCS::#{@name}>"
  end
  alias to_s inspect

  def valid? cp
    cp >= @min && cp <= @max
  end

  # Maps a codepoint to its UCS value.
  def to_ucs cp
    raise CES::EncodingError, "invalid codepoint #{render_codepoint cp}" unless valid? cp
    # the default implementation works for any fully UCS-compatible CCS
    cp
  end

  # Maps a UCS codepoint to its local value.
  def from_ucs cp
    raise CES::EncodingError, "invalid codepoint #{render_codepoint cp}" unless valid? cp
    # the default implementation works for any fully UCS-compatible CCS
    cp
  end

  # This doesn't care about validity.
  def render_codepoint cp
    '[%04X]' % cp
  end
end

dir = File.dirname(__FILE__)
Dir["#{dir}/ccs/*.rb"].each do |fn|
  fn[0..dir.length] = ''
  fn.sub! /\.rb$/, ''
  require_relative fn
end

# vim: ts=2:sts=2:sw=2:expandtab
