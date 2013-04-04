require 'test/unit'
$VERBOSE = true

require './send_if'
class Test_send_if < Test::Unit::TestCase
	def test_send_if_respond_to
		assert_equal( "ABC", 'abc'.send_if_respond_to(:upcase) )
		assert_nil(          12345.send_if_respond_to(:upcase) )
	end
	def test_and_send
		a = {'a'=>{'a'=>{'a'=>'a'}}}
		b = {'a'=>{}}

		assert_equal( "a", a.and_send(:[],'a').and_send(:[],'a').and_send(:[],'a') )
		assert_nil(        b.and_send(:[],'a').and_send(:[],'a').and_send(:[],'a') )
	end
end

