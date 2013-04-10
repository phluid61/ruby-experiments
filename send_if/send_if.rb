
class Object
	def send_if_respond_to meth, *args
		respond_to?(meth) ? __send__(meth, *args) : nil
	end

	def send_if_not_nil meth, *args
		__send__ meth, *args
	end

	def send_if_true meth, *args
		__send__ meth, *args
	end

	def if_not_nil &b
		yield self
	end

	def if_true &b
		yield self
	end
end

def nil.send_if_not_nil *args; self; end
def nil.send_if_true *args; self; end
def false.send_if_true *args; self; end

def nil.if_not_nil &b; self; end
def nil.if_true &b; self; end
def false.if_true &b; self; end
