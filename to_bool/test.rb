require 'test/unit'
$VERBOSE = true

class MyEnum
	include Enumerable
	def initialize(*a) @a=a; end
	def each(&b) @a.each(&b); end
end

$truthy = [ 1, 1.0, Float::INFINITY, -Float::INFINITY, (1<<100).coerce(1).first, Rational(1,1), "x", [1], {1=>1}, MyEnum.new(1), [1].each ]
$falsy  = [ 0, 0.0, -0.0, Float::NAN, (1<<100).coerce(0).first, Rational(0,1), "", [], {}, MyEnum.new, [].each, RuntimeError.new ]

require_relative './to_bool'
class Test_to_bool < Test::Unit::TestCase

	alias :assert_true :assert
	def assert_false val, msg=UNASSIGNED
		assert !val, msg
	end
	def true_msg o, m=nil
		m &&= ".#{m}"
		"#{o.inspect}#{m} should be true"
	end
	def false_msg o, m=nil
		m &&= ".#{m}"
		"#{o.inspect}#{m} should be false"
	end

	def test_Bool
		assert_true( Bool(true), true_msg(true) )
		assert_false( Bool(false), false_msg(false) )
		assert_false( Bool(nil), false_msg(false) )
		$truthy.each do |o|
			assert_true( Bool(o), true_msg(o) )
		end
		$falsy.each do |o|
			assert_true( Bool(o), true_msg(o) )
		end
	end

	def test_to_bool
		assert_true( true.to_bool, true_msg(true,'to_bool') )
		assert_false( false.to_bool, false_msg(false,'to_bool') )
		assert_false( nil.to_bool, false_msg(nil,'to_bool') )
		$truthy.each do |o|
			assert_true( o.to_bool, true_msg(o,'to_bool') )
		end
		$falsy.each do |o|
			assert_true( o.to_bool, true_msg(o,'to_bool') )
		end
	end

	def test_to_b
		assert_true( true.to_b, true_msg(true,'to_b') )
		assert_false( false.to_b, false_msg(false,'to_b') )
		assert_false( nil.to_b, false_msg(nil,'to_b') )
		$truthy.each do |o|
			assert_true( o.to_b, true_msg(o,'to_b') )
		end
		$falsy.each do |o|
			assert_false( o.to_b, false_msg(o,'to_b') )
		end
	end
end

