
require 'base64'

module RFC5234
  ALPHA  = /(?x: [\x41-\x5A] | [\x61-\x7A] )/
  BIT    = /(?x: 0 | 1 )/
  CHAR   = /(?x: [\x01-\x7F] )/
  CR     = /(?x: \x0D )/
  CTL    = /(?x: [\x00-\x1F] | \x7F )/
  DIGIT  = /(?x: [0-9] )/
  DQUOTE = /(?x: ["] )/
  HTAB   = /(?x: \x09 )/
  LF     = /(?x: \x0A )/
  OCTET  = /(?x: [\x00-\xFF] )/n
  SP     = /(?x: \x20 )/
  VCHAR  = /(?x: [\x21-\x7E] )/

  HEXDIG = /(?x: #{DIGIT} | (?i:A|B|C|D|E|F) )/
  CRLF   = /(?x: #{CR}#{LF} )/
  WSP    = /(?x: #{SP} | #{HTAB} )/

  LWSP   = /(?x: (?: #{WSP} | #{CRLF}#{WSP} )* )/
end

module RFC7230
  include RFC5234

  OWS    = /(?x: (?: #{SP} | #{HTAB} )* )/
  RWS    = /(?x: (?: #{SP} | #{HTAB} )+ )/
  BWS    = OWS
end

module HTTPStructuredHeaders
  include RFC7230

  def self.parse input_string, as=:item
    input_string = consume_ows input_string
    result, input_string = case as
    when :dictionary
      parse_dictionary input_string
    when :list
      parse_list input_string
    when :label
      parse_parameterised_label input_string
    else #:item
      parse_item input_string
    end
    input_string = consume_ows input_string
    raise "trailing data in header value: #{input_string.inspect}" unless input_string.empty?
    result
  end

  # return [result_object, rest_of_input_string]
  def self.parse_dictionary input_string
    dictionary = {}
    until input_string.empty?
      this_key, input_string = parse_label input_string
      raise "duplicate key #{this_key.inspect} in dictionary" if dictionary.key? this_key

      first_char, input_string = consume_char input_string
      raise "dictionary missing '=' symbol after #{this_key.inspect}" unless first_char == '='

      this_value, input_string = parse_item input_string
      dictionary[this_key] = this_value
      raise "too many items in dictionary" if dictionary.length > 1024

      input_string = consume_ows input_string
      break if input_string.empty?

      first_char, input_string = consume_char input_string
      raise "bad character #{first_char.inspect} in dictionary, expected ','" unless first_char == ','
      input_string = consume_ows input_string
    end
    [dictionary, input_string]
  end

  # return [result_object, rest_of_input_string]
  def self.parse_list input_string
    list = []
    until input_string.empty?
      item, input_string = parse_item input_string
      list << item
      raise "too many items in list" if list.length > 1024

      input_string = consume_ows input_string
      break if input_string.empty?

      first_char, input_string = consume_char input_string
      raise "bad character #{first_char.inspect} in list, expected ','" unless first_char == ','
      input_string = consume_ows input_string
    end
    [list, input_string]
  end

  # return [result_object, rest_of_input_string]
  def self.parse_parameterised_label input_string
    primary_label, input_string = parse_label input_string
    parameters = {}
    loop do
      input_string = consume_ows input_string

      break unless input_string.start_with? ';'

      _, input_string = consume_char input_string

      input_string = consume_ows input_string

      param_name, input_string = parse_label input_string
      raise "duplicate parameter #{param_name.inspect}" if parameters.key? param_name

      param_value = nil
      if input_string.start_with? '='
        _, input_string = consume_char input_string
        param_value, input_string = parse_item input_string
      end

      raise "too many parameters for #{primary_label}" if parameters.length > 255
      parameters[param_name] = param_value
    end
    [[primary_label, parameters], input_string]
  end

  # return [result_object, rest_of_input_string]
  def self.parse_item input_string
    input_string = consume_ows input_string
    case input_string[0]
    when '-', DIGIT
      parse_number input_string
    when DQUOTE
      parse_string input_string
    when '*'
      parse_binary input_string
    when LCALPHA
      parse_label input_string
    else
      raise "invalid item"
    end
  end

  # return [result_object, rest_of_input_string]
  def self.parse_number input_string
    # NOTE: this is a bit weird, but it's what the draft (-03) says
    md = /^((?x: #{DIGIT} | - | \. )+)((?m:.*))/.match input_string
    input_number, input_string = md[1], md[2]
    if input_number['.']
      output_number = parse_float input_number
    else
      output_number = parse_integer input_number
    end
    [output_number, input_string]
  end
  # return ieee754_double_precision_float
  def self.parse_float input_number
    # NOTE: this is not how the draft (-03) says to do it, but it
    # comes out the same in the wash
    /^(-?)(#{DIGIT}+)\.(#{DIGIT}+)$/.match input_number do |md|
      n = md[1]
      b = md[2]
      a = md[3]
      raise "too many digits in floating point number #{input_number.inspect}, limit=15" if b.length + a.length > 15
      return Float(input_number)
    end
    raise "invalid floating point number #{input_number.inspect}"
  end
  # return integer
  def self.parse_integer input_number
    /^(-?)(#{DIGIT}{1,19})$/.match input_number do |md|
      int = Integer(input_number)
      raise "integer number #{input_number.inspect} out of bounds" if int < -0x8000000000000000 || int > 0x7fffffffffffffff
      return int
    end
    raise "invalid integer number #{input_number.inspect}"
  end

  # return [result_object, rest_of_input_string]
  def self.parse_string input_string
    output_string = ''

    first_char, input_string = consume_char input_string
    raise "bad first character #{first_char.inspect} in string, expected '\"'" unless first_char == '"'

    until input_string.empty?
      char, input_string = consume_char input_string

      if char == '\\'
        raise "unterminated string" if input_string.empty?
        next_char, input_string = consume_char input_string
        raise "invalid escape sequence #{(char+next_char).inspect}" unless next_char == '"' || next_char == '\\'
        output_string << next_char
      elsif char == '"'
        return [output_string, input_string]
      else
        output_string << char
      end
      raise "string too long (> 1024 chars)" if output_string.bytesize > 1024
    end

    raise "unterminated string"
  end

  # return [result_object, rest_of_input_string]
  def self.parse_label input_string
    raise "invalid label, must start with lowercase alphabetic character" unless input_string =~ /^#{LCALPHA}/
    output_string = ''
    until input_string.empty?
      char, input_string = consume_char input_string
      return [output_string, char+input_string] if char !~ /(?x: #{LCALPHA} | #{DIGIT} | _ | - | \* | \/ )/
      output_string << char
      raise "label too long (> 256 chars)" if output_string.bytesize > 256
    end
    [output_string, input_string]
  end

  # return [result_object, rest_of_input_string]
  def self.parse_binary input_string
    first_char, input_string = consume_char input_string
    raise "bad first character #{first_char.inspect} in binary content, expected '*'" unless first_char == '*'
    /([^*]*)\*((?m:.*))$/.match input_string do |md|
      b64_content, input_string = md[1], md[2]
      raise "padding forbidden in base64-encoded binary content" if b64_content['=']
      raise "binary content too long (> 21846 chars)" if b64_content.bytesize > 21846
      ### pad
      n = b64_content.bytesize % 4
      b64_content += ('=' * (4 - n)) if n > 0
      ###
      return [Base64.strict_decode64(b64_content), input_string]
    end
    raise "unterminated binary content"
  end

  # return rest_of_input_string
  def self.consume_ows input_string
    input_string.sub /^#{OWS}/, ''
  end

  # return [first_char, rest_of_input_string]
  def self.consume_char input_string
    [input_string[0], input_string[1..-1]]
  end

  LCALPHA = /(?x: [\x61-\x7A] )/
  LABEL   = /(?x: #{LCALPHA} (?: #{LCALPHA} | #{DIGIT} | _ | - | \* | \/ ){,255} )/
end

# vim: set ts=2 sts=2 sw=2 expandtab
