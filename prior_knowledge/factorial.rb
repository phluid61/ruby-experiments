
def fact(i)i<0?nil:(i==0?1:i*fact(i-1));end

FACT=Hash.new{|h,i|i<0?nil:h[i]=i*h[i-1]}.update(0=>1)

Fact = Object.new.tap{|o| o.instance_eval{
	@a = [1,1,2,6,24,120,720,5040,40320,362880,3628800]
	def [] n
		return nil if n < 0
		if n > (m=@a.length)
			@a[n] = nil
			(m..n).each do |i|
				@a[i] = i * @a[i-1]
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
simple_bench('fact') { fact(25) }
simple_bench('FACT') { FACT[25] }
simple_bench('Fact') { Fact[25] }

puts '', '25 (2) :'
simple_bench('fact') { fact(25) }
simple_bench('FACT') { FACT[25] }
simple_bench('Fact') { Fact[25] }

puts '', '50 (1):'
simple_bench('fact') { fact(50) }
simple_bench('FACT') { FACT[50] }
simple_bench('Fact') { Fact[50] }

puts '', '25 (3):'
simple_bench('fact') { fact(25) }
simple_bench('FACT') { FACT[25] }
simple_bench('Fact') { Fact[25] }

puts '', '50 (2):'
simple_bench('fact') { fact(50) }
simple_bench('FACT') { FACT[50] }
simple_bench('Fact') { Fact[50] }

