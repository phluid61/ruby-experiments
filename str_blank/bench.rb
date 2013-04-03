require 'benchmark'
require './blank'
require './str_blank'

st = '          ';
sf = '         a';
sg = 'a         ';
n = 1_000_000
Benchmark.bm(20) do |x|
	x.report('st.blank?' ) { for i in 1..n; st.blank?; end }
	#x.report('sf.blank?') { for i in 1..n; sf.blank?; end }
	#x.report('sg.blank?') { for i in 1..n; sg.blank?; end }
	x.report('st.rb_blank?' ) { for i in 1..n; st.rb_blank?; end }
	#x.report('sf.rb_blank?') { for i in 1..n; sf.rb_blank?; end }
	#x.report('sg.rb_blank?') { for i in 1..n; sg.rb_blank?; end }
	x.report('st.const_blank?' ) { for i in 1..n; st.const_blank?; end }
	#x.report('sf.const_blank?') { for i in 1..n; sf.const_blank?; end }
	#x.report('sg.const_blank?') { for i in 1..n; sg.const_blank?; end }
	x.report('st.glob_blank?' ) { for i in 1..n; st.glob_blank?; end }
	#x.report('sf.glob_blank?') { for i in 1..n; sf.glob_blank?; end }
	#x.report('sg.glob_blank?') { for i in 1..n; sg.glob_blank?; end }
end

