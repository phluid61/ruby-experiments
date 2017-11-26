# encoding: BINARY
# frozen_string_literal: true

require_relative 'ccs'

##
# Character encoding scheme (maps integer codepoints to sequences of octets).
#
# Usually these are tightly coupled to the CCS (UTF-8 and UTF-16 as specified
# only ever encode UCS, for example) but there's no *technical* reason, so we
# allow you to do weird stuff.
#
class CES
  def initialize default_ccs, &block
    @default_ccs = default_ccs
    instance_eval(&block) if block_given?
  end
  attr_reader :default_ccs

  ##
  # @return serialization
  def encode codepoints, ccs=nil
    ccs ||= default_ccs

    s = Serialization.new '', self, ccs
    codepoints.each do |cp|
      s << encode_one(cp, ccs)
    end
    s
  end

  ##
  # @return [codepoints...]
  def decode octets, ccs=nil
    octets = octets.to_str unless octets.is_a? String
    ccs ||= default_ccs

    codepoints = []
    while octets && !octets.empty?
      cp, octets = decode_one(octets, ccs)
      codepoints << cp
    end
    codepoints
  end

  ##
  # @return octets
  def encode_one codepoint, ccs # rubocop:disable Lint/UnusedMethodArgument
    raise NotImplementedError
  end

  ##
  # @return [codepoint, remainder|nil] or nil
  def decode_one octets, ccs # rubocop:disable Lint/UnusedMethodArgument
    raise NotImplementedError
  end
end

require_relative 'ces/utf8'
require_relative 'ces/utf16'
require_relative 'ces/utf32'

# vim: ts=2:sts=2:sw=2:expandtab
