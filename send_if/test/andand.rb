require 'test/unit'
$VERBOSE = true

class A
  def initialize; @b = B.new; end
  attr_accessor :b
end

class B
  def initialize; @c = C.new; end
  attr_accessor :c
end

class C
  def to_i; 1; end
end

def nil.c
	2
end

require_relative '../andand'
class Test_andand < Test::Unit::TestCase
	def test_andand_nil
		a = A.new
		assert_equal( 1, a._?.b.c.to_i._! )
		a.b.c = nil
		assert_nil( a._?.b.c.to_i._! )
		a.b = nil
		assert_nil( a._?.b.c.to_i._! )
		a = nil
		assert_nil( a._?.b.c.to_i._! )
	end
	def test_andand_false
		a = A.new
		assert_equal( 1, a._?.b.c.to_i._! )
		a.b.c = false
		assert_equal( false, a._?.b.c.to_i._! )
		a.b = false
		assert_equal( false, a._?.b.c.to_i._! )
		a = false
		assert_equal( false, a._?.b.c.to_i._! )
	end
end

