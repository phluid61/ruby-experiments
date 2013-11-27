require 'test/unit'

$VERBOSE = true
require_relative 'sequences'

class TestBitSequence < Test::Unit::TestCase
	def test_initialization
		assert_equal "#<BitSequence:->", BitSequence.new.inspect
		assert_equal "#<BitSequence:10101100>", BitSequence.from_i(0b10101100).inspect
		[
		  [ BitSequence.new, nil, true, 0 ],
			[ BitSequence.new(0), 0, true, 0 ],
			[ BitSequence.new(1), 1, true, 1 ],
			[ BitSequence.new{0}, nil, false, 0 ],
			[ BitSequence.new{1}, nil, false, 1 ],
			[ BitSequence.new{|i,s| i & 1 }, nil, false, 3&1 ],
		].each {|bs, d, pn, mi|
			dflt = bs.default
			if d
				assert_equal (dflt && dflt.to_i), d, bs.inspect
			else
				assert_nil dflt, bs.inspect
			end
			assert_equal pn, bs.default_proc.nil?, bs.inspect
			assert_equal mi, bs.missing_item(3).to_i, bs.inspect
		}

	end
	def test_arrayification
		assert_equal "[]", BitSequence.new.to_a.inspect
		assert_equal "[#<Bit:1>, #<Bit:0>]", BitSequence.from_i(0b10).to_a.inspect
	end
	def test_intification
		assert_equal 0, BitSequence.new.to_i
		assert_equal 0b10101100, BitSequence.from_i(0b10101100).to_i
	end
	def test_stringification
		assert_equal "", BitSequence.new.to_s
		assert_equal "10101100", BitSequence.from_i(0b10101100).to_s
	end
	def test_extractification
		assert_equal 1, BitSequence.from_i(0b10101100)[0].to_i, 'first'
		assert_equal 0, BitSequence.from_i(0b10101100)[1].to_i
		assert_equal 1, BitSequence.from_i(0b10101100)[2].to_i
		assert_equal 0, BitSequence.from_i(0b10101100)[7].to_i, 'last'
		assert_equal 0, BitSequence.from_i(0b10101100)[8].to_i, 'overflow by one'
		assert_equal 0, BitSequence.from_i(0b10101100)[9].to_i, 'overflow by two'
		assert_equal 0, BitSequence.new[0].to_i,														'()'
		assert_equal 0, BitSequence.new(0)[0].to_i,													'(0)'
		assert_equal 1, BitSequence.new(1)[0].to_i,													'(1)'
		assert_equal 1, BitSequence.new(1){puts "block called";0}[0].to_i,	'(1,0){0}'
		assert_equal 1, BitSequence.new{1}[0].to_i,													'block with no args'
		assert_equal 1, BitSequence.new{|i|(i+1)&1}[0].to_i,								'block with index'
		assert_equal 0, BitSequence.new{|i,s|s.default}.to_i,								'block with index,self'

		assert_equal '', BitSequence.new.fetch(0,'')
		assert_equal 1, BitSequence.new.fetch(0){1}.to_i
		assert_equal 0, BitSequence.new.fetch(0){|i| i }.to_i
		assert_equal 0, BitSequence.new.fetch(0){|i,s| s.default }.to_i
	end
	def test_assignification
		assert_equal "#<BitSequence:001>", BitSequence.new.tap{|bs| bs[2] = 1 }.inspect
		assert_equal "#<BitSequence:000>", BitSequence.new.tap{|bs| bs[2] = 0 }.inspect
		assert_equal "#<BitSequence:111>", BitSequence.new(1).tap{|bs| bs[2] = 1 }.inspect
		assert_equal "#<BitSequence:110>", BitSequence.new(1).tap{|bs| bs[2] = 0 }.inspect

		assert_equal "#<BitSequence:001>", BitSequence.new.tap{|bs| bs.store(2, 1, 0) }.inspect
		assert_equal "#<BitSequence:110>", BitSequence.new.tap{|bs| bs.store(2, 0, 1) }.inspect
		assert_equal "#<BitSequence:001>", BitSequence.new(1).tap{|bs| bs.store(2, 1, 0) }.inspect
		assert_equal "#<BitSequence:110>", BitSequence.new(1).tap{|bs| bs.store(2, 0, 1) }.inspect
	end

	def test_subsequences
		bs = BitSequence.from_i(0b1010)
		assert_equal 0b1010, bs.subsequence(0).to_i
		assert_equal 0b010, bs.subsequence(1).to_i
		assert_equal 0b10, bs.subsequence(2).to_i
		assert_equal 0b0, bs.subsequence(3).to_i

		assert_equal 0b1010, bs.subsequence(0,4).to_i
		assert_equal 0b101, bs.subsequence(0,3).to_i
		assert_equal 0b10, bs.subsequence(0,2).to_i
		assert_equal 0b1, bs.subsequence(0,1).to_i
		assert_equal 0, bs.subsequence(0,0).length

		assert_equal 0b010, bs.subsequence(1,3).to_i
		assert_equal 0b01, bs.subsequence(1,2).to_i
		assert_equal 0b0, bs.subsequence(1,1).to_i
		assert_equal 0, bs.subsequence(1,0).length

		assert_equal 0b10, bs.subsequence(2,2).to_i
		assert_equal 0b1, bs.subsequence(2,1).to_i
		assert_equal 0, bs.subsequence(2,0).length

		assert_equal 0b0, bs.subsequence(3,1).to_i
		assert_equal 0, bs.subsequence(3,0).length
	end

	def test_push_right
		bs = BitSequence.from_i(0b101)
		3.times{ bs.push(1) }
		assert_equal 0b101111, bs.to_i
	end
	def test_pop_right
		bs = BitSequence.from_i(0b101)
		assert_equal [0b1, 0b10], [bs.pop.to_i, bs.to_i]
	end

	def test_unshift_left
		bs = BitSequence.from_i(0b101)
		3.times{ bs.unshift(1) }
		assert_equal 0b111101, bs.to_i
	end
	def test_shift_left
		bs = BitSequence.from_i(0b101)
		assert_equal [0b1, 0b01], [bs.shift.to_i, bs.to_i]
	end
	def test_rotate
		[
			[0, 0b1100],
			[1, 0b1001],
			[2, 0b0011],
			[3, 0b0110],
			[4, 0b1100],
			[5, 0b1001],
			[-1, 0b0110],
			[-2, 0b0011],
		].each do |n,x|
			bs = BitSequence.from_i(0b1100)
			assert_equal x, bs.rotate(n).to_i, n.to_s
		end
	end
	def test_bitwise_NOT
		[
			[0b1, 0b0],
			[0b11, 0b00],
			[0b101, 0b010],
		].each do |n,x|
			bs = BitSequence.from_i(n)
			assert_equal x, (~bs).to_i
		end
		assert_equal 4, (~BitSequence.from_i(0b1111)).length
	end
	def test_bitwise_AND
		[
			[0b0000, 0b0000],
			[0b1111, 0b1100],
			[0b1010, 0b1000],
			[0b0101, 0b0100],
		].each do |n,x|
			bs = BitSequence.from_i(0b1100)
			assert_equal x, (bs & n).to_i
		end
	end
	def test_bitwise_OR
		[
			[0b0000, 0b1100],
			[0b1111, 0b1111],
			[0b1010, 0b1110],
			[0b0101, 0b1101],
		].each do |n,x|
			bs = BitSequence.from_i(0b1100)
			assert_equal x, (bs | n).to_i
		end
	end
	def test_bitwise_XOR
		[
			[0b0000, 0b1100],
			[0b1111, 0b0011],
			[0b1010, 0b0110],
			[0b0101, 0b1001],
		].each do |n,x|
			bs = BitSequence.from_i(0b1100)
			assert_equal x, (bs ^ n).to_i
		end
	end
end

