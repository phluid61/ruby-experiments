# encoding: BINARY
# frozen_string_literal: true

class Text
  ##
  # Generic exception class for encoding problems.
  #
  class TextError < RuntimeError
  end

  ##
  # Codepoint is not valid in this CCS, or has no mapping.
  #
  class InvalidCodepoint < TextError
  end

  ##
  # Codepoint cannot be encoded in this CES.
  #
  class UnencodableCodepoint < TextError
  end

  ##
  # Error encoding or decoding codepoints.
  #
  class EncodingError < TextError
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
