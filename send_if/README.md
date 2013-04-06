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

## `send_if_nil_nil`

```ruby
object.send_if_not_nil(:method)
```

is equivalent to:

```ruby
object.nil ? nil : object.send(:method)
```

## `send_if_true`

```ruby
object.send_if_true(:method)
```

is equivalent to:

```ruby
object && object.send(:method)
```

## `if_not_nil`

```ruby
object.if_not_nil{|obj| obj.method }
```

is equivalent to:

```ruby
object.nil ? nil : object.method
```

## `if_true`

```ruby
object.if_true{|obj| obj.method }
```

is equivalent to:

```ruby
object && object.method
```
