require 'rspec/core'
require 'rspec/expectations'

require_relative '../lib/text'

RSpec.describe Text do
  it "has the right \#length" do
    3.times do |n|
      array = [1] * n
      text = Text.new(array, nil)
      expect(text.length).to eq(n)
    end
  end

  it "can be cast to a frozen Array with \#to_a" do
    3.times do |n|
      array = [1] * n
      text = Text.new(array, nil)
      expect(text.to_a).to eq(array)
      expect(text.to_a).to be_frozen
    end
  end

  it "can be iterated (by codepoint) with \#each" do
    array = 3.times.to_a
    text = Text.new(array, nil)
    i = 0
    text.each do |codepoint|
      expect(codepoint).to eq(i)
      i += 1
    end
    expect(i).to eq(3)
  end

  it "returns an Enumerable for \#each if no block is given" do
    array = 3.times.to_a
    text = Text.new(array, nil)
    text.each.with_index do |codepoint, i|
      expect(codepoint).to eq(i)
    end
  end

  it "can be converted to a UTF-8 string with \#to_ruby_string" do
    text = Text.new([0x41, 0x42, 0x43], CCS::UCS)
    string = text.to_ruby_string
    expect(string).to eq('ABC')
    expect(string.encoding).to eq(Encoding::UTF_8)
  end

  it "can be created from a valid String" do
    string = 'ABC'
    text = Text.from_ruby_string(string)
    expect(text.to_a).to eq([0x41, 0x42, 0x43])
    expect(text.ccs).to eq(CCS::UCS)
  end

  it "can be created from an invalid String" do
    string = [0xF1, 0xF2, 0xF3].pack('C*').force_encoding(Encoding::UTF_8)
    text = Text.from_ruby_string(string)
    expect(text.to_a).to eq([0xF1, 0xF2, 0xF3])
    expect(text.ccs).to eq(CCS::WINDOWS_1252)
  end

  [
    [
      'ASCII string',
      'ABC 123'.dup.force_encoding(Encoding::UTF_8),
      nil,
    ],
    [
      'ASCII string with controls',
      "ABC 123\n".dup.force_encoding(Encoding::UTF_8),
      /ISO-8859-. \(strict\)|CP437/,
    ],
    [
      '8-bit string',
      "\u{00E6}".dup.force_encoding(Encoding::UTF_8),
      /US-ASCII|ISO-8859-[23].*/,
    ],
    [
      '8-bit string (2)',
      "\u{00F0}".dup.force_encoding(Encoding::UTF_8),
      /US-ASCII|ISO-8859-[234].*|CP437/,
    ],
    [
      '8-bit controls',
      "\u{0080}".dup.force_encoding(Encoding::UTF_8),
      /US-ASCII|ISO-8859-. \(strict\)|Windows-1252|CP437/,
    ],
    [
      '8-bit controls (2)',
      "\u{0090}".dup.force_encoding(Encoding::UTF_8),
      /US-ASCII|ISO-8859-. \(strict\)|CP437/,
    ],
    [
      'astral emoji',
      "\xF0\x9F\xA4\x94".dup.force_encoding(Encoding::UTF_8),
      /US-ASCII|ISO-8859-.+|Windows-1252|CP437/,
    ],
  ].each do |label, str, failures|
    context "given an #{label}" do
      text = Text.from_ruby_string(str)
      [
        [CES::UTF8],
        [CES::UTF16],
        [CES::UTF32],
        [CES::SBCS, CCS::ASCII],
        [CES::SBCS, CCS::ISO_8859_1],
        [CES::SBCS, CCS::ISO_8859_1_Strict],
        [CES::SBCS, CCS::ISO_8859_2],
        [CES::SBCS, CCS::ISO_8859_2_Strict],
        [CES::SBCS, CCS::ISO_8859_3],
        [CES::SBCS, CCS::ISO_8859_3_Strict],
        [CES::SBCS, CCS::ISO_8859_4],
        [CES::SBCS, CCS::ISO_8859_4_Strict],
        [CES::SBCS, CCS::WINDOWS_1252],
        [CES::SBCS, CCS::CP437],
      ].each do |args|
        if args[1] && (args[1].name =~ /^(#{failures})$/)
          it "should not transcode to #{args.join '+'}" do
            expect { text.transcode_and_serialize(*args) }.to raise_error(CES::EncodingError)
          end
        else
          it "should transcode to #{args.join '+'}" do
            text.transcode_and_serialize(*args)
          end
        end
      end
    end
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
