# encoding: BINARY
# frozen_string_literal: true

##
# A sequence of octets, along with encoding information (CES, CCS)
#
class Serialization
  # +octets+ is not validated against +ces+ or +ccs+, which can have
  # flow-on effects in #to_str, #each_char, etc.
  def initialize octets, ces, ccs
    octets = octets.to_str unless octets.is_a? String
    octets = octets.dup.freeze unless octets.frozen?

    @octets = octets
    @ces = ces
    @ccs = ccs
  end
  attr_reader :octets, :ces, :ccs

  def inspect
    "\#<Serialization octets=\"#{@octets.each_byte.map{|b| '\\x%02X' % b }.join}\" ces=#{@ces.inspect} ccs=#{@ccs.inspect}>"
  end

  def to_str
    @octets.dup.force_encoding Encoding::ASCII_8BIT
  end
  alias to_s to_str

  def each_byte &block
    return enum_for(:each_byte) unless block_given?
    @octets.each_byte(&block)
    nil
  end

  def each_char &block
    return enum_for(:each_char) unless block_given?
    @chars ||= @ces.decode(@octets, @ccs, true).freeze
    @chars.each(&block)
    nil
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
