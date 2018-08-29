require 'test/unit'
$VERBOSE = true

class TraversalDummy
  attr_accessor :path
  def fetch item
    @path << item
    self
  end
end

require_relative '../traverse'
class Test_traverse < Test::Unit::TestCase
  # Test nested hashed
  def test_traverse_hash
    h = { 'a'=>{ 'b'=>{ 'c'=>1 } } }
    # no-block mode
    assert_equal( 1, h.traverse('a','b','c') )
    assert_nil( h.traverse('a','b','c','x') ) # overrun
    assert_nil( h.traverse('a','b','x') )     # no key
    assert_nil( h.traverse('a','x') )         # no key
    assert_nil( h.traverse('a','x','y') )     # no key > overrun
    assert_nil( h.traverse('x','y','z') )     # no key > overrun
    # block-mode
    assert_equal( 1, h.traverse('a','b','c'){|*q|q} )
    assert_equal( [1,          nil], h.traverse('a','b','c','x'){|*q|q} ) # overrun
    assert_equal( [h['a']['b'],'x'], h.traverse('a','b','x'){|*q|q} )     # no key
    assert_equal( [h['a'],     'x'], h.traverse('a','x'){|*q|q} )         # no key
    assert_equal( [h['a'],     'x'], h.traverse('a','x','y'){|*q|q} )     # no key > overrun
    assert_equal( [h,          'x'], h.traverse('x','y','z'){|*q|q} )     # no key > overrun
  end

  # Test nested arrays
  def test_traverse_array
    a = [[[1]]]
    # no-block mode
    assert_equal( 1, a.traverse(0,0,0) )
    assert_nil( a.traverse(0,0,0,1) ) # overrun
    assert_nil( a.traverse(0,0,1) )   # no index
    assert_nil( a.traverse(0,1) )     # no index
    assert_nil( a.traverse(0,1,'x') ) # no index > overrun+typeerr
    assert_nil( a.traverse(1,'x') )   # no index > overrun+typeerr
    # block mode
    assert_equal( 1, a.traverse(0,0,0){|*q|q} )
    assert_equal( [1,    nil], a.traverse(0,0,0,1){|*q|q} ) # overrun
    assert_equal( [a[0][0],1], a.traverse(0,0,1){|*q|q} )   # no index
    assert_equal( [a[0],   1], a.traverse(0,1){|*q|q} )     # no index
    assert_equal( [a[0],   1], a.traverse(0,1,'x'){|*q|q} ) # no index > overrun+typeerr
    assert_equal( [a,      1], a.traverse(1,'x'){|*q|q} )   # no index > overrun+typeerr
    # extra
    assert_raise(TypeError) { a.traverse('x') }
    assert_raise(TypeError) { a.traverse('x'){|*q|q} }
  end

  # Test mixed nestings of hashes and arrays
  def test_traverse_mixed
    h = {'a'=>[{'c'=>1}]}
    a = [{'b'=>[1]}]

    # no-block mode - pass
    assert_equal( 1, h.traverse('a',0,'c') )
    assert_equal( 1, a.traverse(0,'b',0) )
    # -- fail
    assert_nil( h.traverse('a',0,'c',0) ) # overrun
    assert_nil( h.traverse('a',0,'x') )   # no key
    assert_nil( h.traverse('a',1,'c') )   # no index > overrun
    assert_nil( h.traverse('x',0,'c') )   # no key > overrun

    assert_nil( a.traverse(0,'b',0,'c') ) # overrun
    assert_nil( a.traverse(0,'b',1) )     # no index
    assert_nil( a.traverse(0,'x',0) )     # no key > overrun
    assert_nil( a.traverse(1,'b',0) )     # no index > overrun

    # block mode -- pass
    assert_equal( 1, h.traverse('a',0,'c'){|*q|q} )
    assert_equal( 1, a.traverse(0,'b',0){|*q|q} )
    # -- fail
    assert_equal( [1,        nil], h.traverse('a',0,'c',1){|*q|q} ) # overrun
    assert_equal( [h['a'][0],'x'], h.traverse('a',0,'x'){|*q|q} )   # no key
    assert_equal( [h['a'],    1 ], h.traverse('a',1,'c'){|*q|q} )   # no index > overrun
    assert_equal( [h,        'y'], h.traverse('y',0,'c'){|*q|q} )   # no key > overrun

    assert_equal( [1,        nil], a.traverse(0,'b',0,'x'){|*q|q} ) # overrun
    assert_equal( [a[0]['b'], 1 ], a.traverse(0,'b',1){|*q|q} )     # no index
    assert_equal( [a[0],     'x'], a.traverse(0,'x',0){|*q|q} )     # no key > overrun
    assert_equal( [a,         2 ], a.traverse(2,'b',0){|*q|q} )     # no index > overrun
    # extra
    assert_raise(TypeError) { h.traverse('a','b','c') }
    assert_raise(TypeError) { h.traverse('a','b','c'){|*q|q} }
  end

  # Test traversing hashes with default values
  def test_traverse_default_value
    h = Hash.new( 'foo' )
    a = Hash.new( 'bar' )
    b = Hash.new( 'baz' )
    h['a'] = a; a['b'] = b; b['c'] = 1

    assert_equal( 1, h.traverse('a','b','c') )
    # without overrun
    assert_equal( 'baz', h.traverse('a','b','x') )
    assert_equal( 'bar', h.traverse('a','x') )
    assert_equal( 'foo', h.traverse('x') )
    # with overrun
    assert_equal( 'baz', h.traverse('a','b','x','y') )
    assert_equal( 'bar', h.traverse('a','x','c','y') )
    assert_equal( 'foo', h.traverse('x','b','c','y') )
  end

  # Test traversing hashes with default procs
  def test_traverse_default_proc
    h = Hash.new {|h,k| 'foo' }
    a = Hash.new {|h,k| 'bar' }
    b = Hash.new {|h,k| 'baz' }
    h['a'] = a; a['b'] = b; b['c'] = 1

    assert_equal( 1, h.traverse('a','b','c') )
    # without overrun
    assert_equal( 'baz', h.traverse('a','b','x') )
    assert_equal( 'bar', h.traverse('a','x') )
    assert_equal( 'foo', h.traverse('x') )
    # with overrun
    assert_equal( 'baz', h.traverse('a','b','x','y') )
    assert_equal( 'bar', h.traverse('a','x','c','y') )
    assert_equal( 'foo', h.traverse('x','b','c','y') )
  end

  # Test that an explicit 'nil' at the end of the path is returned, even
  # if a default block is given
  def test_traverse_edgecase1
    h = {'a'=>{'b'=>{'c'=>nil}}}
    assert_equal( 'foo', h.traverse('a','b','x'){'foo'} )
    assert_nil( h.traverse('a','b','c'){'foo'} )
  end
end

