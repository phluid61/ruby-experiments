=begin
Copyright (c) 2013, Matthew Kerwin
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
=end

#
# A module that attempts to provide some of the expressive power offered
# by MOO Code through the following  language constructs:
#
#   `unsafe_expression ! ANY'
#   `unsafe_expression ! ANY => fallback_expression'
#   `unsafe_expression ! E_FOO, E_BAR'
#   `unsafe_expression ! E_FOO, E_BAR => fallback_expression'
#
# In Ruby these become:
#
#   Try.try { unsafe_expression }
#   Try.trap(Exception=>fallback) { unsafe_expression }  # OR: unsafe_expression rescue fallback
#   Try.trap(FooError, BarError) { unsafe_expression}
#   Try.trap(FooError=>fallback, BarError=>fallback) { unsafe_expression }
#
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
  # value if passed as (({Type => value})) pairs.
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
      return value if klass.instance_of?(Module) ? ex.kind_of?(klass) : ex.is_a?(klass)
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

