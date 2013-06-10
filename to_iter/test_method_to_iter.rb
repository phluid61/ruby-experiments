require 'test/unit'
require './method_to_iter.rb'
class MethodToIterTest < Test::Unit::TestCase
  def test_to_iter
    # Test on Integer#next => Integer
    assert_equal([0, 1, 2, 3, 4], 0.method(:next).to_iter.take(5))
    # Test on String#succ => String
    assert_equal(%w[a b c d e f g h i j], 'a'.method(:succ).to_iter.take(10))
    # Test on Integer#inspect => String#inspect => String
    assert_equal([1, "1", "\"1\""], 1.method(:inspect).to_iter.take(3))
  end
  def test_iter_for_args
    # Test with a parameter
    assert_equal([0, 2, 4, 6, 8], 0.method(:+).to_iter(2).take(5))
  end
end
