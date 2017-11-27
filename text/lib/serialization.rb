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
    # FIXME: this assumes all Unicode encodings use the
    # right coded character set. Could get messy ...
    case ces
    when CES::UTF8, CES::UTF8_Relaxed
      @octets.dup.force_encoding Encoding::UTF_8
    when CES::UTF16
      @octets.dup.force_encoding Encoding::UTF_16BE
    when CES::UCS2
      @octets.dup.force_encoding Encoding::UCS_2BE
    when CES::UTF32, CES::UTF32_Relaxed
      @octets.dup.force_encoding Encoding::UTF_32BE
    when CES::UCS4
      @octets.dup.force_encoding Encoding::UCS_4BE
    when CES::SBCS
      case @ccs
      when CCS::ASCII
        @octets.dup.force_encoding Encoding::US_ASCII
      when CCS::ISO8859_1
        @octets.dup.force_encoding Encoding::ISO_8859_1
      when CCS::WINDOWS1252
        @octets.dup.force_encoding Encoding::Windows_1252
      when CCS::CP437
        @octets.dup.force_encoding Encoding::IBM437
      end
    end
  end
  alias to_s to_str

  def each_byte &block
    @octets.each_byte(&block)
  end

  def each_char &block
    @chars ||= @ces.decode(@octets, @ccs, true).freeze
    @chars.each(&block)
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
