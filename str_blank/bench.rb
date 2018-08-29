require 'benchmark'
require './blank'

st = '          ';
sf = '         a';
sg = 'a         ';
n = 1_000_000
Benchmark.bm(20) do |x|
  puts "true (worst case)"
  x.report('st.blank?') { for i in 1..n; st.blank?; end }
  x.report('st.rb_blank?') { for i in 1..n; st.rb_blank?; end }
  puts "false (worst case)"
  x.report('sf.blank?') { for i in 1..n; sf.blank?; end }
  x.report('sf.rb_blank?') { for i in 1..n; sf.rb_blank?; end }
  puts "false (best case)"
  x.report('sg.blank?') { for i in 1..n; sg.blank?; end }
  x.report('sg.rb_blank?') { for i in 1..n; sg.rb_blank?; end }
end

