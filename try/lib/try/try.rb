# vim:ts=2:sw=2:sts=2

#
# Evaluates the given block and returns its value.
# If an exception is raised, that exception is returned instead.
#
def try
	yield
rescue Exception => ex
	ex
end

