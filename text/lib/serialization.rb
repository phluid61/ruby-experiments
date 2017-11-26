# encoding: BINARY
# frozen_string_literal: true

##
# A sequence of octets, along with encoding information (CES, CCS)
#
# +octets+ is not validated against +ces+ or +ccs+
#
class Serialization
  def initialize octets, ces, ccs
    octets = octets.to_str unless octets.is_a? String
    octets = octets.dup.freeze unless octets.frozen?

    @octets = octets
    @ces = ces
    @ccs = ccs
  end
  attr_reader :octets, :ces, :ccs

  def to_str
    @octets
  end

  def each_byte &block
    @octets.each_byte(&block)
  end

  def each_char &block
    @chars ||= @ces.decode(@octets, @ccs, true).freeze
    @chars.each(&block)
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
