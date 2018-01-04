# encoding: BINARY
# frozen_string_literal: true

require_relative 'exceptions'
require_relative 'ccs'

##
# Character encoding scheme (maps integer codepoints to sequences of octets).
#
# Usually these are tightly coupled to the CCS (UTF-8 and UTF-16 as specified
# only ever encode UCS, for example) but there's no *technical* reason, so we
# allow you to do weird stuff.
#
class CES
  def self.instances
    (@@instances || []).dup
  end

  def self.each &block
    return enum_for(:each) unless block_given?
    (@@instances || []).each(&block)
  end

  def initialize name, default_ccs, &block
    @name = name.to_str.dup.freeze
    @default_ccs = default_ccs
    instance_eval(&block) if block_given?

    @@instances ||= []
    @@instances << self
  end
  attr_reader :name, :default_ccs

  def inspect
    "\#<CES::#{@name}>"
  end
  alias to_s inspect

  ##
  # @return serialization
  #
  def encode codepoints, ccs=nil, was_ucs=true
    ccs ||= default_ccs

    buffer = ''.dup
    codepoints.each do |cp|
      buffer << encode_one(cp, ccs)
    end
    Serialization.new buffer, self, ccs
  end

  ##
  # @return [codepoints...]
  #
  def decode octets, ccs=nil, as_chars=false
    octets = octets.to_str unless octets.is_a? String
    ccs ||= default_ccs

    codepoints = []
    while octets && !octets.empty?
      cp, octets = decode_one(octets, ccs)
      cp = encode_one(cp, ccs) if as_chars
      codepoints << cp
    end
    codepoints
  end

  ##
  # @return octets
  #
  def encode_one codepoint, ccs # rubocop:disable Lint/UnusedMethodArgument
    raise NotImplementedError
  end

  ##
  # @return [codepoint, remainder|nil] or nil
  #
  def decode_one octets, ccs # rubocop:disable Lint/UnusedMethodArgument
    raise NotImplementedError
  end

  ##
  # @throw Text::TextError of some sort, probably
  #
  def transcode codepoints, from, to=nil
    return codepoints if from == self
    codepoints.map do |cp|
      ucs_cp = from.to_ucs(cp)
      (to || @default_ccs).from_ucs(ucs_cp)
    end
  end
end

dir = File.dirname(__FILE__)
Dir["#{dir}/ces/*.rb"].each do |fn|
  fn[0..dir.length] = ''
  fn.sub! /\.rb$/, ''
  require_relative fn
end

# vim: ts=2:sts=2:sw=2:expandtab
