Send If
=======

## chicken-typing

```ruby
object.send_if_respond_to :method
```

is equivalent to:

```ruby
object.respond_to?(:method) ? object.send(:method) : nil
```

## if not nil

```ruby
object.send_if_not_nil(:method)
object.if_not_nil{|obj| obj.method }
```

is equivalent to:

```ruby
object.nil ? nil : object.method
```

## if truthy

```ruby
object.send_if_true(:method)
object.if_true{|obj| obj.method }
object.maybe{ method }
object.maybe.method
```

is equivalent to:

```ruby
object && object.method
```
