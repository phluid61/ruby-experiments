# vim:ts=2:sw=2:sts=2
require 'test/unit'

$VERBOSE = true
require "#{File.dirname File.dirname(__FILE__)}/lib/try"

$OLD_RUBY = (RUBY_VERSION.to_f < 1.9)
if $OLD_RUBY
	# Monkeypatch, for Ruby 1.8 that didn't define INFINITY or NAN
  Float::INFINITY = Object.new
end

$benign  = proc { 1 }
$runtime = proc { raise 'Raised a RuntimeError' }
$typeerr = proc { raise TypeError,  'Raised a TypeError' }
$rangeerr= proc { raise RangeError, 'Raised a RangeError' }
$zerodiv = proc { 1 / 0 }
$fallback= proc { 2 }
$fallthru= proc {|ex| ex }

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
		assert_equal(2, Try.trap(RuntimeError=>$fallback,&$runtime))
		assert_instance_of(RuntimeError, Try.trap(RuntimeError=>$fallthru,&$runtime))
		assert_instance_of(RuntimeError, Try.trap(RuntimeError=>Try::ORIG,&$runtime))
		# Multiple mappings
		assert_equal(0, Try.trap(RuntimeError=>0,TypeError=>1,&$runtime))
		assert_equal(1, Try.trap(RuntimeError=>0,TypeError=>1,&$typeerr))
		assert_instance_of(TypeError, Try.trap(RuntimeError=>0,TypeError=>Try::ORIG,&$typeerr))
		# Everything
		assert_instance_of(RuntimeError, Try.trap(RuntimeError,TypeError=>0,StandardError=>1,&$runtime))
		if !$OLD_RUBY
			# Note: before 1.9 ruby didn't have insertion-ordered hashes
			assert_equal(0, Try.trap(RuntimeError,TypeError=>0,StandardError=>1,&$typeerr))
			assert_equal(1, Try.trap(RuntimeError,TypeError=>0,StandardError=>1,&$rangeerr))
		end
		# Old-school hierarchy-based trap hack
		assert_equal(0, Try.trap(StandardError=>1){ Try.trap(RuntimeError,TypeError=>0,&$typeerr) } )
		assert_equal(1, Try.trap(StandardError=>1){ Try.trap(RuntimeError,TypeError=>0,&$rangeerr) } )
		# New-school hierarchy-based trap
		assert_instance_of(RangeError, Try.trap(ZeroDivisionError=>Float::INFINITY, StandardError=>Try::ORIG,&$rangeerr))
		if !$OLD_RUBY
			# FIXME: test relies on insertion-ordered hash.
			assert_equal(Float::INFINITY, Try.trap(ZeroDivisionError=>Float::INFINITY, StandardError=>Try::ORIG,&$zerodiv))
		end
		# Miss
		assert_raise(RangeError) { Try.trap(RuntimeError,TypeError=>0,&$rangeerr) }
	end
	def test_test
		# No args
		assert( Try.test(&$benign) )
		assert_equal(nil, Try.test(&$runtime) )
		# Args hit
		assert( Try.test(RuntimeError,&$benign) )
		assert_equal(nil, Try.test(RuntimeError,&$runtime) )
		# Args miss
		assert_raise(TypeError) { Try.test(RuntimeError,&$typeerr) }
	end
end

