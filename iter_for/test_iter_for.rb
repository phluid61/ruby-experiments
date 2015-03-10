require 'test/unit'
require './iter_for.rb'
class IterForTest < Test::Unit::TestCase
  def test_iter_for
    # Test on Integer#next => Integer
    assert_equal([0, 1, 2, 3, 4], 0.iter_for(:next).take(5))
    # Test on String#succ => String
    assert_equal(%w[a b c d e f g h i j], 'a'.iter_for(:succ).take(10))
    # Test on Integer#inspect => String#inspect => String
    assert_equal([1, "1", "\"1\""], 1.iter_for(:inspect).take(3))
  end
  def test_iter_for_args
    # Test with a parameter
    assert_equal([0, 2, 4, 6, 8], 0.iter_for(:+, 2).take(5))
  end
end
