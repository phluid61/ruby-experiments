# encoding: BINARY
# frozen_string_literal: true

##
# A sequence of octets, along with encoding information (CES, CCS)
class Serialization
  def initialize octets, ces, ccs
    octets = octets.to_str unless octets.is_a? String
    octets = octets.dup.freeze unless octets.frozen?

    @octets = octets
    @ces = ces
    @ccs = ccs
  end
  attr_reader :octets, :ces, :ccs

  # Unsafe -- accepts any sequence of octets here
  def << octets
    octets = octets.to_str unless octets.is_a? String
    @octets = (@octets + octets).freeze
    self
  end

  def to_str
    @octets
  end

  def each_byte &block
    @octets.each_byte(&block)
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
