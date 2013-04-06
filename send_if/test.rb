require 'test/unit'
$VERBOSE = true

$a = {'x'=>{'y'=>{'z'=>'a'}}}
$b = {'x'=>{}}
$c = {'x'=>{'y'=>false}}

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

require './send_if'
class Test_send_if < Test::Unit::TestCase
	def test_send_if_respond_to
		assert_equal( "ABC", 'abc'.send_if_respond_to(:upcase) )
		assert_nil(          12345.send_if_respond_to(:upcase) )
	end
	def test_send_if_not_nil
		trial = lambda{|h| h.send_if_not_nil(:[],'x').send_if_not_nil(:[],'y').send_if_not_nil(:[],'z') }

		assert_equal( "a", trial[$a] )
		assert_nil(        trial[$b] )
		assert_raise(NoMethodError) { trial[$c] }
	end
	def test_send_if_true
		trial = lambda{|h| h.send_if_true(:[],'x').send_if_true(:[],'y').send_if_true(:[],'z') }

		assert_equal( "a", trial[$a] )
		assert_nil(        trial[$b] )
		assert_equal(false,trial[$c] )
	end
	def test_if_not_nil
		trial = lambda{|h| h.if_not_nil{|h|h['x']}.if_not_nil{|x|x['y']}.if_not_nil{|y|y['z']} }

		assert_equal( "a", trial[$a] )
		assert_nil(        trial[$b] )
		assert_raise(NoMethodError) { trial[$c] }
	end
	def test_if_true
		trial = lambda{|h| h.if_true{|h|h['x']}.if_true{|x|x['y']}.if_true{|y|y['z']} }

		assert_equal( "a", trial[$a] )
		assert_nil(        trial[$b] )
		assert_equal(false,trial[$c] )
	end
	def test_if_not_nil_abortive
		trial = lambda{|h| h.if_not_nil{|h|h['x'].if_not_nil{|x|x['y'].if_not_nil{|y|y['z']}}} }

		assert_equal( "a", trial[$a] )
		assert_nil(        trial[$b] )
		assert_raise(NoMethodError) { trial[$c] }
	end
	def test_if_true_abortive
		trial = lambda{|h| h.if_true{|h|h['x'].if_true{|x|x['y'].if_true{|y|y['z']}}} }

		assert_equal( "a", trial[$a] )
		assert_nil(        trial[$b] )
		assert_equal(false,trial[$c] )
	end
	def test_maybe
		a = A.new
		# block
		assert_equal( 1, a.maybe{ b.maybe{ c } }.to_i )
		assert_equal( 1, a.maybe{ b.c.to_i } )
		assert_equal( 1, a.maybe{ b }.c.to_i )
		# delegator
		assert_equal( 1, a.maybe.b.maybe.c.to_i )
		assert_equal( 1, a.maybe.b.c.to_i )
		a.b.c = nil
		# block
		assert_nil( a.maybe{ b.maybe{ c } } )
		assert_nil( a.maybe{ b.c } )
		assert_nil( a.maybe{ b }.c )
		# delegator
		assert_nil( a.maybe.b.maybe.c )
		assert_nil( a.maybe.b.c )
		a.b = nil
		# block
		assert_nil( a.maybe{ b.maybe{ c } } )
		assert_raise(NoMethodError) { a.maybe{ b.c } }
		assert_raise(NoMethodError) { a.maybe{ b }.c }
		# delegator
		assert_nil( a.maybe.b.maybe.c )
		assert_raise(NoMethodError) { a.maybe.b.c }
		a = nil
		# block
		assert_nil( a.maybe{ b.maybe{ c } } )
		assert_nil( a.maybe{ b.c } )
		assert_raise(NoMethodError) { a.maybe{ b }.c }
		# delegator
		assert_nil( a.maybe.b.maybe.c )
		assert_raise(NoMethodError) { a.maybe.b.c }
	end
end
