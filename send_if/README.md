Send If
=======

## `send_if_respond_to`

```ruby
object.send_if_respond_to :method
```

is equivalent to:

```ruby
object.respond_to?(:method) ? object.send(:method) : nil
```

## `and_send`

```ruby
object.and_send(:method)
```

is equivalent to:

```ruby
object && object.send(:method)
```
