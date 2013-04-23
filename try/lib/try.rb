=begin
A module that attempts to provide some of the expressive power offered
by MOO Code through the following  language constructs:

  `unsafe_expression ! ANY'
  `unsafe_expression ! ANY => fallback_expression'
  `unsafe_expression ! E_FOO, E_BAR'
  `unsafe_expression ! E_FOO, E_BAR => fallback_expression'

In Ruby these become:

  Try.try { unsafe_expression }  # OR: unsafe_expression rescue $!
  Try.trap(Exception=>fallback) { unsafe_expression }  # OR: unsafe_expression rescue fallback
  Try.trap(FooError, BarError) { unsafe_expression}
  Try.trap(FooError=>fallback, BarError=>fallback) { unsafe_expression }

=end
module Try
  #
  # Evaluates the given block and returns its value.
  # If an exception is raised, that exception is returned instead.
  #
  def try &bk
    yield
  rescue Exception => ex
    ex
  end

  #
  # Evaluates the given block and returns its value.
  #
  # Specific exception types can be trapped by passing them as
  # parameters.
  #
  # Additionally, specific exception types can default to a fallback
  # value if passed as (({Type => value})) pairs.  If the +value+ is
  # a Proc, it is called and the exception object is passed as a
  # parameter.
  #
  # Any un-trapped exception is raised normally.
  #
  # @param errs a list of exception types to trap.
  #
  def trap *errs, &bk
    hash = {}
    hash = errs.pop if errs.last.is_a? Hash
    errs.each {|ec| hash[ec] = ec }
    yield
  rescue Exception => ex
    errs.each do |klass|
      return ex if klass.instance_of?(Module) ? ex.kind_of?(klass) : ex.is_a?(klass)
    end
    hash.each_pair do |klass,value|
      return value.is_a?(Proc) ? value.call(ex) : value if klass.instance_of?(Module) ? ex.kind_of?(klass) : ex.is_a?(klass)
    end
    raise
  end

  #
  # Evaluates the given block and returns its value.
  # If an exception is raised, nil is returned instead.
  #
  # If ((%errs%)) are given, only those exceptions will be trapped,
  # and any other exceptions will be raised normally.
  #
  # @param errs an optional list of exception types to trap.
  #
  def test *errs, &bk
    yield
  rescue Exception => ex
    return nil if errs.empty?
    errs.each do |klass|
      return nil if klass.instance_of?(Module) ? ex.kind_of?(klass) : ex.is_a?(klass)
    end
    raise
  end

  extend self
end

=begin
Copyright (c) 2013, Matthew Kerwin <matthew@kerwin.net.au>

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
=end

