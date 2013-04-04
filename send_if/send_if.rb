
class Object
	def send_if_respond_to meth, *args
		respond_to?(meth) ? send(meth, *args) : nil
	end

	def send_if_not_nil meth, *args
		send meth, *args
	end

	def send_if_true meth, *args
		send meth, *args
	end
end

def nil.send_if_not_nil *args; self; end
def nil.send_if_true *args; self; end
def false.send_if_true *args; self; end

