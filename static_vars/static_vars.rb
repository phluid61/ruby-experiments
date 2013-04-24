=begin
 Experimental library that adds Java-esque "static variable"
 functionality to all Ruby classes.  These static variables differ
 from class variables particularly in that they are shadowed in
 overriding subclasses rather than writing back.

 Author:  Matthew Kerwin <matthew@kerwin.net.au>
=end

class Class
	@static_vars = {}

	#
	# Returns an Array containing all the static variables defined directly on this class.
	#
	def static_vars
		@static_vars ||= {}
	end

	#
	# Like ancestors, but grabs only true superclasses.
	#
	def superclasses
		c = self
		real = []
		until c.nil?
			real << c
			c = c.superclass
		end
		real
	end

	#
	# Get the java-esque name of this Class.
	#
	def java_name
		superclasses.reverse.map{|a|a.name}.join('.')
	end

	#
	# Define a static variable.
	#
	def static_variable_set var_name, value
		var_name = var_name.to_s.to_sym unless var_name.is_a? Symbol
		static_vars[var_name] = value
	end

	#
	# Returns true if the given static variable is defined.
	#
	def static_variable_defined? var_name
		var_name = var_name.to_s.to_sym unless var_name.is_a? Symbol
		superclasses.any?{|cl| cl.static_vars.has_key? var_name }
	end

	#
	# Retrieve a static variable.
	#
	def static_variable_get var_name
		var_name = var_name.to_s.to_sym unless var_name.is_a? Symbol
		superclasses.each do |cl|
			sv = cl.static_vars
			return sv[var_name] if sv.key? var_name
		end
		$VERBOSE && warn( "warning: static variable #{var_name} not initialized" )
		nil
	end

	#
	# Returns an Array containing all the static variables accessible by this class.
	#
	def static_variables
		vars = {}
		superclasses.each do |cl|
			cl.static_vars.keys.each{|sv| vars[sv] = true }
		end
		vars.keys
	end
end
