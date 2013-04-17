Boolean Conversions
===================

`Bool(o)`
---------

Converts _o_ to a boolean, using the same logic as `o ? true : false`.

`Object.to_bool`
----------------

Converts the object to a boolean, using the same logic as `o ? true : false`.

`Object.to_b`
-------------

Converts the object to a boolean, using "typical" conversion rules.

The following values all become false:

* `0`, `0.0`, etc. (any numeric zero)
* `Float::NAN`
* `""`
* `[]`, `{}`, etc. (any Enumerable or Enumerator with no elements)
* any Exception

Any other value is converted to true.

