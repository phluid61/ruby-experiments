
class Object
	def send_if_respond_to meth, *args
		respond_to?(meth) ? send(meth, *args) : nil
	end

	def and_send meth, *args
		send meth, *args
	end
end

def nil.and_send *args; self; end
def false.and_send *args; self; end

