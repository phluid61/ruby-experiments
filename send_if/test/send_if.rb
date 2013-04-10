require 'test/unit'
$VERBOSE = true

$a = {'x'=>{'y'=>{'z'=>'a'}}}
$b = {'x'=>{}}
$c = {'x'=>{'y'=>false}}

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
end
