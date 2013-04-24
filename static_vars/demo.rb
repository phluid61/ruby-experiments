$VERBOSE = true

require_relative 'static_vars'

# -------------------------------------------------------------------
puts "\n1. create a class:"

class A
end

print "  A.static_variable_get(:some_var) => "; p A.static_variable_get(:some_var)
print "  A.static_variables => "; p A.static_variables
print "  A.static_vars => "; p A.static_vars

# -------------------------------------------------------------------
puts "\n2. create a class with 'some_var' equal to 7:"

class B
	B.static_variable_set :some_var, 7
end

print "  B.static_variable_get(:some_var) => "; p B.static_variable_get(:some_var)
print "  B.static_variables => "; p B.static_variables
print "  B.static_vars => "; p B.static_vars

# -------------------------------------------------------------------
puts "\n3. change it to 43:"

B.static_variable_set :some_var, 43

print "  B.static_variable_get(:some_var) => "; p B.static_variable_get(:some_var)
print "  B.static_variables => "; p B.static_variables
print "  B.static_vars => "; p B.static_vars

# -------------------------------------------------------------------
puts "\n4. create a subclass C < B:"

class C < B
end

print "  C.static_variable_get(:some_var) => "; p C.static_variable_get(:some_var)
print "  B.static_variable_get(:some_var) => "; p B.static_variable_get(:some_var)

print "  B.static_variables => "; p B.static_variables
print "  C.static_variables => "; p C.static_variables

print "  B.static_vars => "; p B.static_vars
print "  C.static_vars => "; p C.static_vars

# -------------------------------------------------------------------
puts "\n5. change some_var in C:"

C.static_variable_set(:some_var, 'hello')

print "  B.static_variables => "; p B.static_variables
print "  C.static_variables => "; p C.static_variables

print "  B.static_vars => "; p B.static_vars
print "  C.static_vars => "; p C.static_vars

print "  C.static_variable_get(:some_var) => "; p C.static_variable_get(:some_var)
print "  B.static_variable_get(:some_var) => "; p B.static_variable_get(:some_var)

# -------------------------------------------------------------------
puts "\n6. change some_var in B:"

B.static_variable_set(:some_var, -1)

print "  C.static_variable_get(:some_var) => "; p C.static_variable_get(:some_var)
print "  B.static_variable_get(:some_var) => "; p B.static_variable_get(:some_var)


# -------------------------------------------------------------------
puts "\n7. other stuff"

print "define B.foo => "; p B.static_variable_set('foo','foo')
print "  B.static_variable_defined?('foo') => "; puts B.static_variable_defined?('foo')
print "  C.static_variable_defined?('foo') => "; puts C.static_variable_defined?('foo')
print "  C.static_variable_get(:foo) => "; p C.static_variable_get(:foo)
print "  B.static_variable_get(:foo) => "; p B.static_variable_get(:foo)

print "define C.bar => "; p C.static_variable_set('bar','bar')
print "  B.static_variable_defined?('bar') => "; puts B.static_variable_defined?('bar')
print "  C.static_variable_defined?('bar') => "; puts C.static_variable_defined?('bar')
print "  C.static_variable_get(:bar) => "; p C.static_variable_get(:bar)
print "  B.static_variable_get(:bar) => "; p B.static_variable_get(:bar)

print "B.static_variables => "; p B.static_variables
print "C.static_variables => "; p C.static_variables

print "B.static_vars => "; p B.static_vars
print "C.static_vars => "; p C.static_vars
