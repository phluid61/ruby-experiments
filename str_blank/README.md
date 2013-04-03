Blank
=====

Experiments with various `String#blank?` whatchermajiggers.

Benchmarks
----------

Two methods:
* `blank?` is the native C implementation
* `rb_blank?` is the straight-forward regex implementation

Tested on three strings:
* `st = '________'` -- worst case (passes after last char)
* `sf = '_______a'` -- worst case (fails on last char)
* `sg = 'a_______'` -- best case (fails on first char)

(Note: underscores represent space chars.)

### Ruby 2.1.0
```
                           user     system      total        real
true (worst case)
st.blank?              0.190000   0.000000   0.190000 (  0.193207)
st.rb_blank?           0.770000   0.000000   0.770000 (  0.772237)
false (worst case)
sf.blank?              0.200000   0.000000   0.200000 (  0.194367)
sf.rb_blank?           0.540000   0.000000   0.540000 (  0.545911)
false (best case)
sg.blank?              0.080000   0.000000   0.080000 (  0.078579)
sg.rb_blank?           0.330000   0.000000   0.330000 (  0.325979)
```
### Ruby 1.9.1
```
true (worst case)
st.blank?              0.180000   0.000000   0.180000 (  0.184056)
st.rb_blank?           0.720000   0.000000   0.720000 (  0.720227)
false (worst case)
sf.blank?              0.190000   0.000000   0.190000 (  0.187118)
sf.rb_blank?           0.530000   0.000000   0.530000 (  0.533837)
false (best case)
sg.blank?              0.080000   0.000000   0.080000 (  0.081545)
sg.rb_blank?           0.350000   0.000000   0.350000 (  0.348165)
```
