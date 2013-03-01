# vim:ts=2:sw=2:sts=2

require 'test/unit'
if Kernel.method_defined? :require_relative
	require_relative 'try.rb'
else
	require './try.rb'
end

$benign  = proc { 1 }
$runtime = proc { raise 'Raised a RuntimeError' }
$typeerr = proc { raise TypeError,  'Raised a TypeError' }
$rangeerr= proc { raise RangeError, 'Raised a RangeError' }

class TestTry < Test::Unit::TestCase
	def test_try
		assert_equal(1, try(&$benign))
		assert_instance_of(RuntimeError, try(&$runtime))
	end
	def test_on
		# Single exception class
		assert_equal(1, try_rescue(RuntimeError,&$benign) )
		assert_instance_of(RuntimeError, try_rescue(RuntimeError,&$runtime))
		# Multiple exception classes
		assert_instance_of(TypeError, try_rescue(TypeError,RuntimeError,&$typeerr))
		assert_instance_of(RuntimeError, try_rescue(TypeError,RuntimeError,&$runtime))
		# Mapped exception value
		assert_equal(0, try_rescue(RuntimeError=>0,&$runtime))
		# Multiple mappings
		assert_equal(0, try_rescue(RuntimeError=>0,TypeError=>1,&$runtime))
		assert_equal(1, try_rescue(RuntimeError=>0,TypeError=>1,&$typeerr))
		# Everything
		assert_instance_of(RuntimeError, try_rescue(RuntimeError,TypeError=>0,StandardError=>1,&$runtime))
		assert_equal(0, try_rescue(RuntimeError,TypeError=>0,StandardError=>1,&$typeerr))
		assert_equal(1, try_rescue(RuntimeError,TypeError=>0,StandardError=>1,&$rangeerr))
		# Miss
		assert_raise(RangeError) { try_rescue(RuntimeError,TypeError=>0,&$rangeerr) }
	end
end

