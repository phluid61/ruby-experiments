require_relative 'lib/text'

def banner text
  puts "\e[32m", '*', text.gsub(/^/, '* '),  "*\e[0m"
end

def wee_banner text
  puts "\e[36m", text.gsub(/^/, '* ') + "\e[0m"
end

[
  ['simple ASCII string', 'ABC 123'.force_encoding(Encoding::UTF_8)],
  ['ASCII string with controls', "ABC 123\n".force_encoding(Encoding::UTF_8)],
#  ['8-bit string', "\u{00E6}".force_encoding(Encoding::UTF_8)],
  ['8-bit string (2)', "\u{00F0}".force_encoding(Encoding::UTF_8)],
  ['8-bit controls', "\u{0080}".force_encoding(Encoding::UTF_8)],
  ['8-bit controls (2)', "\u{0090}".force_encoding(Encoding::UTF_8)],
#  ['astral emoji', "\xF0\x9F\xA4\x94".force_encoding(Encoding::UTF_8)],
].each do |label, str|
  banner label

  p [str, str.encoding]

  text = Text.from_ruby_string(str)
  p text

  [
    [CES::UTF8],
    [CES::UTF16],
    [CES::UTF32],
    [CES::SBCS, CCS::ASCII],
    [CES::SBCS, CCS::ISO8859_1],
    [CES::SBCS, CCS::ISO8859_1_Strict],
    [CES::SBCS, CCS::ISO8859_2],
    [CES::SBCS, CCS::ISO8859_2_Strict],
    [CES::SBCS, CCS::ISO8859_3],
    [CES::SBCS, CCS::ISO8859_3_Strict],
    [CES::SBCS, CCS::ISO8859_4],
    [CES::SBCS, CCS::ISO8859_4_Strict],
    [CES::SBCS, CCS::WINDOWS1252],
    [CES::SBCS, CCS::CP437],
  ].each do |args|
    begin
      wee_banner "to #{args.first}+#{(args[1] || args.first.default_ccs)}"
      p text.serialize(*args)

      srl = text.transcode_and_serialize(*args)
      p srl

      srls = srl.to_s
      p [srls, srls.encoding]
    rescue RuntimeError => e
      puts "\e[91m#{e.inspect}\e[0m"
    end
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
