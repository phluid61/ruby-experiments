Try
===

MOO Code[1] had the following language construct:

```
`unsafe_expression ! ANY'
`unsafe_expression ! ANY => fallback_expression'
`unsafe_expression ! E_FOO, E_BAR'
`unsafe_expression ! E_FOO, E_BAR => fallback_expression'
```

Where `E_FOO, E_BAR` is a comma-separated list of error codes[2] that should
be caught if raised by the unsafe_expression.[3]

If an error is raised by the unsafe_expression, the forms without a fallback
expression return the error code that was caught.  The other two forms
evaluate the fallback_expression and return its value.

Ruby supports a similar, but limited, construct; for example:

```ruby
a = 1 / 0 rescue 'oops'
# => a == "oops"
```

This experiment attempts to capture some of that expressive functionality in a
Rubyish way.

1. MOO Code: http://tecfa.unige.ch/guides/MOO/ProgMan/ProgrammersManual_toc.html
2. http://tecfa.unige.ch/guides/MOO/ProgMan/ProgrammersManual_3.html#SEC3
3. http://tecfa.unige.ch/guides/MOO/ProgMan/ProgrammersManual_26.html#SEC26

### `try`

Evaluates the given block and returns its value.  If an exception is raised
during execution, that exception object is returned instead.

#### Examples

```ruby
require 'try'
Try.try { 1 }            # => 1
Try.try { raise 'oops' } # => #<RuntimeError: oops>
```

### `trap(*errs)`

Evaluates the given block and returns its value.  If an exception is raised
during execution, and that exception is a `kind_of?` one of the *errs* given,
the exception object is returned instead.

Additionally, an Exception class can be associated with a specific return
value, for example an IOError could be replaced by an empty string.

#### Examples

```ruby
require 'try'
Try.trap(RuntimeError) { raise 'oops' }     # => #<RuntimeError: oops>
Try.trap(RuntimeError) { 1 / 0 }            # => (raises ZeroDivisionError)
Try.trap(RuntimeError=>-1) { raise 'oops' } # => -1
Try.trap(RuntimeError, Exception=>nil) { raise 'oops' } # => #<RuntimeError: oops>
Try.trap(RuntimeError, Exception=>nil) { 1 / 0 }        # => nil
```

### `test(*errs)`

Evaluates the given block and returns true unless an exception is raised.

If `errs` are given, only those exceptions will be trapped, and any others
will be raised normally.

#### Examples

```ruby
require 'try'
Try.test { 1 }             # => true
Try.test { raise 'oops' }  # => false
Try.test(RuntimeError) { raise 'oops' } # => false
Try.test(RuntimeError) { 1 / 0 }        # => (raises ZeroDivisionError)
```

Known Limitations
-----------------

### Ordering

Error types are tested in the order they are given in *errs*, much the way
they would be in `begin; rescue a; rescue b; rescue c; end`.

Because the value-substitution form uses Ruby's magic hash parameter syntax,
the mapped parameters must necessarily all come after the unmapped parameters.

Also: there is no syntax to map an exception type to its instance (i.e. to
make it behave like an unmapped parameter).

As such, the following nesting structure may be required:

```ruby
trap(StandardError) do
  trap(ZeroDivisionError => Float::INFINITY) { 1 / n }
end
```

...to replace a ZeroDivisonError with Infinity, but catch any other
StandardError (of which ZeroDivisionError is a subclass) and return it
in-place.

### Early Evaluation

In the MOO Code example, the fallback_expression is only evaluated if the
relevant error is thrown.  However all fallbacks in *trap* are evalulated
_before the block is executed_.

