#!/usr/bin/ruby
# vim:ts=2:sw=2:sts=2

if RUBY_VERSION =~ /^1\.8\./
	$ignore = [Object, Kernel]
else
	$ignore = [BasicObject, Object, Kernel]
end

exceptions = []
tree = {}
ObjectSpace.each_object(Class) do |cls|
	next unless cls.ancestors.include? Exception
	next if exceptions.include? cls
	next if cls.superclass == SystemCallError # avoid dumping Errnos
	exceptions << cls
	cls.ancestors.delete_if{|e| $ignore.include? e }.reverse.inject(tree){|memo,cls| memo[cls] ||= {} }
end

indent = 0
tree_printer = Proc.new do |t|
	t.keys.sort{|a,b| (a.name||a.inspect) <=> (b.name||b.inspect) }.each do |k|
		space = (' ' * indent)
		puts space + k.to_s
		indent += 2; tree_printer.call t[k]; indent -= 2
	end
end
tree_printer.call tree

