# Logical Lambdas

This library helps to generate a chain of logic operations that
may accept parameters. The return value is always another
`LogicalLambda` so it is easy to compose many scenarios.
An example might be a recommendation engine:

```ruby
users = [
  Person.new(name: "Dennis", age: 21, height: 72)
  Person.new(name: "Mike", age: 34, height: 60)
  Person.new(name: "Bob", age: 17, height: 48)
]

can_drink = LogicalLambda.new {|p| p.age >= 21}
is_tall   = LogicalLambda.new {|p| p.height >= 72}
is_short  = LogicalLambda.new {|p| p.height <= 48 }
is_older  = LogicalLambda.new {|p| p.age > 70 }

# Note the use of single ampersand and pipe - the bitwise operators.
suggest_soccer     = is_short & !can_drink
suggest_basketball = is_tall | !is_older
suggest_sailing    = !is_tall & can_drink

[dennis, mike, bob].each do |u|
  if suggest_soccer.call(u)
    puts "#{u.name} => Soccer"

  elsif suggest_basketball.call(u)
    puts "#{u.name} => Basketball"

  elsif suggest_sailing.call(u)
    puts "#{u.name} => Sailing"
  end
end

```

The Procs can be compared using `==`, `!=`, `>`, `>=`, `<`, and `<=`:

```ruby
count_foos = LogicalLambda.new {|f| f.count(:foo) }
count_bars = LogicalLambda.new {|f| f.count(:bars) }

has_more_bars = count_bars > count_foos

if has_more_bars.call([:foo, :bar, :bar])
  puts "has_more_bars is true!"
end
```

You can also compare to primitives like so:
```ruby
has_two_bars = count_bars == 2 # Compare to non-proc

if has_two_bars.call([:foo, :bar, :bar])
  puts "has_two_bars is true!"
end

```

The bang unary operator has been implemented so you can create a NOT condition.

```ruby
is_green = lambda {|v| v == :green}
is_red = lambda {|v| v == :red}

is_green.call(:red) # false
!is_green.call(:red) # true

# Combining not with other logic
(is_green | !is_red).call(:blue) # true

(!is_green & !is_red).call(:purple) # true

```


You should be careful not to use the Procs directly in an `if`
statement without calling `.call`:

```ruby
is_false = lambda {false}

# This code is checking if is_false is present, which is true.
puts "is_false is truthy" if is_false

# What you really want is to evaluate the block with .call
puts "is_false is truthy" if is_false.call # Returns false

```

## Installation
Add `gem "logical_lambda"` to your Gemfile or
run `gem install logical_lambda`.


## Extending Core
You may wish to extend Ruby core so that you can use the `lambda()` or
`proc()` helper functions instead of doing `LogicalLambda.new
{...}`. It's worth a reminder that Procs do not validate parameters
while a lambda will raise exception for too few or too many arguments.

```ruby
class Proc
  include LogicalLambdaMixin
end

is_three = lambda {|f| f == 3}
is_true   = proc {true}

```

## Tests
`rake test`

