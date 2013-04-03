Blank
=====

Experiments with various String#blank? whatchermajiggers.

## Benchmarks

`.blank?` is the native C implementation
`.rb_blank?` is the straight-forward regex implementation

Ruby 2.1.0
```
                           user     system      total        real
st.blank?              0.200000   0.000000   0.200000 (  0.197359)
st.rb_blank?           0.790000   0.000000   0.790000 (  0.789195)
st.const_blank?        0.800000   0.000000   0.800000 (  0.799486)
st.glob_blank?         0.800000   0.000000   0.800000 (  0.803356)
```
Ruby 1.9.1
```
st.blank?              0.180000   0.000000   0.180000 (  0.185382)
st.rb_blank?           0.720000   0.000000   0.720000 (  0.714750)
st.const_blank?        0.750000   0.000000   0.750000 (  0.749577)
st.glob_blank?         0.750000   0.000000   0.750000 (  0.752006)
```
