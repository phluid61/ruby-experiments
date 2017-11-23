# encoding: UTF-8
# frozen_string_literal: true

##
# Coded character set (maps logical 'characters' to tangible 'codepoints')
#
class CCS
  def initialize min, max, &block
    @min = min
    @max = max
    instance_eval(&block) if block_given?
  end

  def valid? cp
    cp >= min && cp <= max
  end

  ##
  # Default Unicode CCS.
  #
  Unicode = CCS.new(0, 0x10FFFF) do
    def valid? cp
      return false unless super
      return false if cp >= 0xD800 && cp <= 0xDFFF
      true
    end
  end

  ##
  # Strict Unicode CCS, that forbids non-character codepoints.
  #
  UnicodeStrict = CCS.new(0, 0x10FFFF) do
    def valid? cp
      return false unless super
      return false if cp >= 0xD800 && cp <= 0xDFFF
      return false if cp >= 0xFDD0 && cp <= 0xFDEF
      return false if (cp & 0xFFFE) == 0xFFFE
      true
    end
  end

  ##
  # 7-bit US-ASCII
  #
  ASCII = CCS.new(0, 127)

  ##
  # 8-bit binary.
  #
  BINARY = CCS.new(0, 255)
end

# vim: ts=2:sts=2:sw=2:expandtab
