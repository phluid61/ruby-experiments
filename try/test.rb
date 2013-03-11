# vim:ts=2:sw=2:sts=2

require 'test/unit'
if Kernel.method_defined? :require_relative
	require_relative 'lib/try'
else
	require './lib/try.rb'
end

$benign  = proc { 1 }
$runtime = proc { raise 'Raised a RuntimeError' }
$typeerr = proc { raise TypeError,  'Raised a TypeError' }
$rangeerr= proc { raise RangeError, 'Raised a RangeError' }

class TestTry < Test::Unit::TestCase
	def test_try
		assert_equal(1, Try.try(&$benign))
		assert_instance_of(RuntimeError, Try.try(&$runtime))
	end
	def test_trap
		# Single exception class
		assert_equal(1, Try.trap(RuntimeError,&$benign) )
		assert_instance_of(RuntimeError, Try.trap(RuntimeError,&$runtime))
		# Multiple exception classes
		assert_instance_of(TypeError, Try.trap(TypeError,RuntimeError,&$typeerr))
		assert_instance_of(RuntimeError, Try.trap(TypeError,RuntimeError,&$runtime))
		# Mapped exception value
		assert_equal(0, Try.trap(RuntimeError=>0,&$runtime))
		# Multiple mappings
		assert_equal(0, Try.trap(RuntimeError=>0,TypeError=>1,&$runtime))
		assert_equal(1, Try.trap(RuntimeError=>0,TypeError=>1,&$typeerr))
		# Everything
		assert_instance_of(RuntimeError, Try.trap(RuntimeError,TypeError=>0,StandardError=>1,&$runtime))
		assert_equal(0, Try.trap(RuntimeError,TypeError=>0,StandardError=>1,&$typeerr))
		assert_equal(1, Try.trap(RuntimeError,TypeError=>0,StandardError=>1,&$rangeerr))
		# Miss
		assert_raise(RangeError) { Try.trap(RuntimeError,TypeError=>0,&$rangeerr) }
	end
	def test_test
		# No args
		assert( Try.test(&$benign) )
		assert(!Try.test(&$runtime) )
		# Args hit
		assert( Try.test(RuntimeError,&$benign) )
		assert(!Try.test(RuntimeError,&$runtime) )
		# Args miss
		assert_raise(TypeError) { Try.test(RuntimeError,&$typeerr) }
	end
end

