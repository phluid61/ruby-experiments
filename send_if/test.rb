require 'test/unit'
$VERBOSE = true

$a = {'a'=>{'a'=>{'a'=>'a'}}}
$b = {'a'=>{}}
$c = {'a'=>{'a'=>false}}

require './send_if'
class Test_send_if < Test::Unit::TestCase
	def test_send_if_respond_to
		assert_equal( "ABC", 'abc'.send_if_respond_to(:upcase) )
		assert_nil(          12345.send_if_respond_to(:upcase) )
	end
	def test_send_if_not_nil
		trial = lambda{|h| h.send_if_not_nil(:[],'a').send_if_not_nil(:[],'a').send_if_not_nil(:[],'a') }

		assert_equal( "a", trial[$a] )
		assert_nil(        trial[$b] )
		assert_raise(NoMethodError) { trial[$c] }
	end
	def test_send_if_true
		trial = lambda{|h| h.send_if_true(:[],'a').send_if_true(:[],'a').send_if_true(:[],'a') }

		assert_equal( "a", trial[$a] )
		assert_nil(        trial[$b] )
		assert_equal(false,trial[$c] )
	end
end

