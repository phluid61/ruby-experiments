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

  include Enumerable

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

  def each
    return enum_for(:each) unless block_given?
    (@min..@max).each {|cp| yield cp if valid? cp }
    nil
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

class TableCCS < CCS
  ##
  # Create a new table-based CCS.
  #
  # @param forward_map - responds to: forward_map[cp] => ucs_cp, forward_map.each_with_index
  # @param reverse_map - responds to: reverse_map[ucs_cp] => cp; if nil, generated from forward_map.each_with_index
  #
  def initialize name, min, max, forward_map, reverse_map=nil, &block
    super(name, min, max, &block)
    @forward = forward_map
    @reverse = reverse_map || Hash[forward_map.each_with_index.to_a]
  end

  def valid? cp
    super(cp) && @forward[cp]
  end

  # Maps a codepoint to its UCS value.
  def to_ucs cp
    raise CES::EncodingError, "invalid codepoint #{render_codepoint cp}" unless valid? cp
    @forward[cp] or raise CES::EncodingError, "invalid codepoint #{render_codepoint cp}"
  end

  # Maps a UCS codepoint to its local value.
  def from_ucs ucs_cp
    cp = @reverse[ucs_cp] or raise CES::EncodingError, "no mapping for UCS codepoint #{CCS::UCS.render_codepoint ucs_cp}"
    raise CES::EncodingError, "invalid codepoint #{render_codepoint cp}" unless valid? cp
    cp
  end
end

dir = File.dirname(__FILE__)
Dir["#{dir}/ccs/*.rb"].each do |fn|
  fn[0..dir.length] = ''
  fn.sub! /\.rb$/, ''
  require_relative fn
end

# vim: ts=2:sts=2:sw=2:expandtab
