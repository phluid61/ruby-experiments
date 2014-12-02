
def fib(n)
	return nil if n < 0
	return n if n < 2
	(n-2).times.inject([1,1]){|x,i|a,b=x;[b,a+b]}[1]
end

FIB=Hash.new{|h,i|i<0?nil:h[i]=h[i-2]+h[i-1]}.update(0=>0,1=>1)

Fib = Object.new.tap{|o| o.instance_eval{
	@a = [0,1,1,2,3,5,8,13,21,34]
	def [] n
		return nil if n < 0
		if n > (m=@a.length)
			@a[n] = nil
			(m..n).each do |i|
				@a[i] = @a[i-1] + @a[i-2]
			end
		end
		@a[n]
	end
}}

require 'timestamp'
def simple_bench t=nil, &b
  print "#{t}: " if t
  a = Time::timestamp
  yield
  b = Time::timestamp
  printf "%12d ns\n", b-a
end

puts '', '25 (1):'
simple_bench('fib') { fib(25) }
simple_bench('FIB') { FIB[25] }
simple_bench('Fib') { Fib[25] }

puts '', '25 (2) :'
simple_bench('fib') { fib(25) }
simple_bench('FIB') { FIB[25] }
simple_bench('Fib') { Fib[25] }

puts '', '50 (1):'
simple_bench('fib') { fib(50) }
simple_bench('FIB') { FIB[50] }
simple_bench('Fib') { Fib[50] }

puts '', '25 (3):'
simple_bench('fib') { fib(25) }
simple_bench('FIB') { FIB[25] }
simple_bench('Fib') { Fib[25] }

puts '', '50 (2):'
simple_bench('fib') { fib(50) }
simple_bench('FIB') { FIB[50] }
simple_bench('Fib') { Fib[50] }

