# vim:ts=2:sw=2:sts=2

if Kernel.method_defined? :require_relative
    require_relative 'hexdump.rb'
else
    require './hexdump.rb'
end

str = "lkjasdlkjasd\nalsdhlkjhaskdjh\n\nlkjhasdkjhaksjhdas\e[1mANSI MAGIC\e[0mklhkjhlysdufkhjknasdfkhjl7yk\nuhdfiuhdsf\t\tlkjhdsf"
#puts "\nThe String:", str
puts "\ninspect:",   str.inspect
puts "\nprintable:", str.printable
puts "\nwrap_hex:",            str.wrap_hex,      '', str.wrap_hex(true)
puts "\nwrap_printable:",      str.wrap_printable,'', str.wrap_printable(true)
puts "\nhexdump:",             str.hexdump,       '', str.hexdump(true)

