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

class Parser
  module Patterns
    include RFC7230

    BASE64      = /(?x: #{ALPHA} | #{DIGIT} | \+ | \/ )/
    BINARY      = /(?x: [*] #{BASE64}{0,21846} [*] )/

    LCALPHA     = /(?x: [\x61-\x7A] )/
    LABEL       = /(?x: #{LCALPHA} (?: #{LCALPHA} | #{DIGIT} | _ | - | \* | \/ ){,255} )/

    UNESCAPED   = /(?x: [\x20-\x21] | [\x23-\x5B] | [\x5D-\x7E] )/
    ESCAPE      = /(?x: [\\] )/
    CHAR        = /(?x: #{UNESCAPED} | #{ESCAPE} (?: #{DQUOTE} | [\\] ) )/
    STRING      = /(?x: #{DQUOTE} #{CHAR}{0,1024} #{DQUOTE} )/

    FLOAT       = /(?x: [-]? (?:
                    #{DIGIT}     [.] #{DIGIT}{1,14} |
                    #{DIGIT}{2}  [.] #{DIGIT}{1,13} |
                    #{DIGIT}{3}  [.] #{DIGIT}{1,12} |
                    #{DIGIT}{4}  [.] #{DIGIT}{1,11} |
                    #{DIGIT}{5}  [.] #{DIGIT}{1,10} |
                    #{DIGIT}{6}  [.] #{DIGIT}{1,9}  |
                    #{DIGIT}{7}  [.] #{DIGIT}{1,8}  |
                    #{DIGIT}{8}  [.] #{DIGIT}{1,7}  |
                    #{DIGIT}{9}  [.] #{DIGIT}{1,6}  |
                    #{DIGIT}{10} [.] #{DIGIT}{1,5}  |
                    #{DIGIT}{11} [.] #{DIGIT}{1,4}  |
                    #{DIGIT}{12} [.] #{DIGIT}{1,3}  |
                    #{DIGIT}{13} [.] #{DIGIT}{1,2}  |
                    #{DIGIT}{14} [.] #{DIGIT}{1}
                  ))/

    INTEGER     = /(?x: [-]? #{DIGIT}{1,19} )/

    ITEM        = /(?x: #{INTEGER} | #{FLOAT} | #{STRING} | #{LABEL} | #{BINARY} )/

    PARAMETERISED =
                  /(?x: #{LABEL} (?: #{OWS} [;] #{OWS} #{LABEL} (?: [=] #{ITEM} )? ){,256} )/

    LIST_MEMBER = /(?x: #{ITEM} | #{PARAMETERISED} )/
    LIST        = /(?x: #{LIST_MEMBER} (?: #{OWS} [,] #{OWS} #{LIST_MEMBER} ){0,1023} )/

    DICTIONARY_MEMBER =
                  /(?x: #{LABEL} [=] #{ITEM} )/
    DICTIONARY  = /(?x: #{DICTIONARY_MEMBER} (?: #{OWS} [,] #{OWS} #{DICTIONARY_MEMBER} ){,1023} )/

    STRUCTURED_HEADER =
                  /(?x:^ #{OWS} (?:
                    (?<dict>   #{DICTIONARY}    ) |
                    (?<item>   #{ITEM}          ) |
                    (?<plabel> #{PARAMETERISED} ) |
                    (?<list>   #{LIST}          )
                  ) $)/
  end
  include Patterns

  class Instance
    include Patterns

    def initialize input_string
      @buffer = (+"#{input_string}").force_encoding(Encoding::BINARY) # safe mutable copy
      ows! # might as well get it out of the way now
    end

    ##
    # Returns a reasonable and illustrative summary of the buffer.
    #
    def summary
      (@buffer.bytesize > 20 ? (@buffer[0..20] + '...') : @buffer).inspect
    end

    ##
    # Returns true iff the buffer is empty.
    #
    # @param ows if given and true, a buffer containing only OWS is considered empty
    #
    def empty? ows=false
      if ows
        /^#{OWS}$/.match(@buffer) && true
      else
        @buffer.empty?
      end
    end

    ##
    # Discards leading OWS from the buffer.
    #
    def ows!
      @buffer.gsub!(/^#{OWS}/, '') && self
    end

    ##
    # Returns the first character of the buffer without consuming it.
    #
    def first
      @buffer[0]
    end

    ##
    # Removes and returns the first character in the buffer.
    # Fails if the buffer is empty.
    #
    def first!
      raise 'buffer empty' if empty?
      result = @buffer[0]
      @buffer[0..0] = ''
      result
    end

    ##
    # Tests whether the buffer starts with 'match'.
    # If so, returns true; otherwise returns falsey.
    #
    # @param match String or Regexp
    #
    def start_with? match
      if match.is_a? Regexp
        /^#{match}/.match(@buffer) && true
      else
        mstr = (match.respond_to?(:to_str) ? match.to_str : match.to_s)
        @buffer.start_with? mstr
      end
    end

    ##
    # Tests that the buffer starts with 'match'.
    # If so, removes the matching part from the start of the buffer
    # and returns it; otherwise returns falsey.
    #
    # @param match String or Regexp
    #
    def start_with_and_consume? match
      if match.is_a? Regexp
        value = false
        @buffer.sub!(/^#{match}/) do |mstr|
          value = mstr
          ''
        end
        value
      else
        mstr = (match.respond_to?(:to_str) ? match.to_str : match.to_s)
        return false unless @buffer.start_with? mstr
        @buffer[0...mstr.bytesize] = ''
        mstr
      end
    end

    ##
    # Extracts a dictionary from the start of the buffer.
    # Consumes the entire buffer.  May be empty (or contain only OWS).
    #
    def extract_dictionary
      dict = {}
      loop do
        key = extract_label
        raise "duplicate key #{key.inspect}" if dict.key? key
        ows!

        raise "key #{key.inspect} missing '='" unless first! == '='
        ows!

        val = extract_item
        ows!

        raise "more than 1024 items in dictionary" if dict.length >= 1024
        dict[key] = val

        return dict if empty?

        fc = first!
        raise "invalid character #{fc.inspect}, expected ','" unless fc == ','
        ows!
      end
    end

    ##
    # Extracts a list from the start of the buffer.
    # Consumes the entire buffer.  May be empty (or contain only OWS).
    #
    def extract_list
      list = []

      loop do
        item = if start_with? /#{LABEL}#{OWS};/
          extract_plabel
        else
          extract_item
        end
        raise "more than 1024 items in list" if list.length >= 1024
        list << item
        ows!

        return list if empty?

        fc = first!
        raise "invalid character #{fc.inspect}, expected ','" unless fc == ','
        ows!
      end
    end

    ##
    # Extracts a parameterised label from the start of the buffer.
    # Consumes the relevant part of the buffer.  Fails if buffer does
    # not start with a parameterised label (including being empty).
    #
    def extract_plabel
      lbl = extract_label
      params = {}
      loop do
        ows!

        break unless start_with_and_consume? ';'
        ows!

        key = extract_label
        raise "duplicate parameter #{key.inspect}" if params.key? key

        val = nil
        val = extract_item if start_with_and_consume? '='

        raise "more than 256 parameters" if params.length >= 256
        params[key] = val
      end
      [lbl, params]
    end

    ##
    # Extracts an item from the start of the buffer.
    # Consumes the relevant part of the buffer.
    #
    def extract_item
      if start_with_and_consume? '"'
        extract_string
      elsif start_with_and_consume? '*'
        extract_binary
      elsif (label = start_with_and_consume? LABEL)
        label
      elsif (fstr = start_with_and_consume? FLOAT)
        Float(fstr)
      elsif (istr = start_with_and_consume? INTEGER)
        int = Integer(istr)
        raise "integer #{istr.inspect} out of bounds" if int < -0x8000000000000000 || int > 0x7fffffffffffffff
        int
      else
        raise "invalid item #{summary}"
      end
    end

    ##
    # Extracts a label from the start of the buffer.
    # Consumes the relevant part of the buffer.
    def extract_label
      start_with_and_consume?(LABEL) or raise "invalid label #{summary}"
    end

    ##
    # Extracts a string from the start of the buffer.
    # Consumes the relevant part of the buffer.
    #
    # Note: the initial '"' must already be consumed.
    #
    def extract_string
      str = (+'').force_encoding(Encoding::BINARY)
      until empty?
        if (slice = start_with_and_consume? /[^"\\]+/)
          str << slice
        end

        raise 'unterminated string' if empty?

        case (c = first!)
        when '"'
          return str
        when '\\'
          raise 'unterminated string' if empty?
          d = start_with_and_consume? /["\\]/
          raise "invalid escape sequence #{(c+first).inspect}" unless d
          str << d
        else
          raise "??BUG: first character should be \\ or \", got #{c.inspect}"
        end
      end
      raise '??BUG: unreachable code'
    end

    ##
    # Extracts a binary sequence from the start of the buffer.
    # Consumes the relevant part of the buffer.
    #
    # Note: the initial '*' must already be consumed.
    #
    def extract_binary
      if (b64 = start_with_and_consume? /#{BASE64}{0,21846}[*]/)
        b64[-1..-1] = ''
        n = b64.bytesize % 4
        b64 += ('=' * (4 - n)) if n > 0
        Base64.strict_decode64 b64
      else
        raise "invalid binary sequence #{summary}"
      end
    end
  end

  def initialize header_value
    @header_value = -"#{header_value}" # safe immutable copy
  end

  def parse_autodetect
    md = STRUCTURED_HEADER.match @header_value
    return nil if md.nil?
    return parse_dictionary if md['dict']
    return parse_list       if md['list']
    return parse_plabel     if md['plabel'] # never happens, caught by 'list'
    return parse_item       if md['item']
    raise "??BUG: unreachable code; #{md.inspect}"
  end

  ##
  # Parses the header value as a dictionary.
  #
  def parse_dictionary
    parser = Instance.new(@header_value)
    parser.extract_dictionary
  end

  ##
  # Parses the header value as a list.
  #
  def parse_list
    parser = Instance.new(@header_value)
    parser.extract_list
  end

  ##
  # Parses the header value as a single parameterised label.
  #
  def parse_plabel
    parser = Instance.new(@header_value)
    plabel = parser.extract_plabel
    raise "unexpected trailing data #{parser.summary}" unless parser.empty? true
    plabel
  end

  ##
  # Parses the header value as a single item.
  #
  def parse_item
    parser = Instance.new(@header_value)
    item = parser.extract_item
    raise "unexpected trailing data #{parser.summary}" unless parser.empty? true
    item
  end
end

# vim: set ts=2 sts=2 sw=2 expandtab
