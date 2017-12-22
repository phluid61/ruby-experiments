require 'rspec/core'
require 'rspec/expectations'

require_relative '../lib/text/serialization'

class NotString
  def to_str
    'ABC'.dup
  end
end

class FakeCES
  def decode *args
    args
  end
end

RSpec.describe Serialization do
  it "stringifies and freezes #octets" do
    [
      'ABC'.dup,
      'ABC'.freeze,
      NotString.new,
    ].each do |input|
      srl = Serialization.new(input, nil, nil)
      oct = srl.octets
      expect(oct).to eq('ABC')
      expect(oct).to be_frozen
    end
  end

  it "can be cast to a binary string with \#to_str" do
    [
      'ABC'.dup,
      'ABC'.freeze,
      NotString.new,
    ].each do |input|
      srl = Serialization.new(input, nil, nil)
      str = srl.to_str
      expect(str).to eq('ABC')
      expect(str.encoding).to eq(Encoding::ASCII_8BIT)
    end
  end

  it "can be iterated (by octet) with \#each_byte" do
    str = [0, 1, 2].pack('C*')
    srl = Serialization.new(str, nil, nil)
    i = 0
    srl.each_byte do |octet|
      expect(octet).to eq(i)
      i += 1
    end
    expect(i).to eq(3)
  end

  it "has a #ces" do
    obj = Object.new
    srl = Serialization.new('', obj, nil)
    expect(srl.ces).to eq(obj)
  end

  it "has a #ccs" do
    obj = Object.new
    srl = Serialization.new('', nil, obj)
    expect(srl.ccs).to eq(obj)
  end

  it "implements #each_char using CES\#decode" do
    str = 'string'
    ces = FakeCES.new
    ccs = Object.new
    srl = Serialization.new(str, ces, ccs)
    x = [str, ccs, true]
    i = 0
    srl.each_char do |c|
      expect(c).to eq(x[i])
      i += 1
    end
    expect(i).to eq(3)
  end
end

# vim: ts=2:sts=2:sw=2:expandtab
