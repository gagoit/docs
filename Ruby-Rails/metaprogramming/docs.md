# Metaprogramming
Metaprogramming is the writing of computer programs that write or manipulate other programs (or themselves) as their data, or that do part of the work at compile time that would otherwise be done at runtime.

Or simply: Metaprogramming is writing **code that writes code** during runtime to make your life easier.

Metaprogramming can be used a way to add, edit or modify the code of your program while it’s running. Using it, you can make new or delete existing methods on objects, reopen or modify existing classes, catch methods that don’t exist, and avoid repetitious coding to keep your program DRY.

In Ruby we can see Metaprogramming in:
- Adding methods in the context of an object
- Open to Change (Monkey patching)
- Writing Code That Writes Code
- #send
- #method_missing
- #define_method

## Adding methods in the context of an object
```ruby
# Example 1:
class Bill
end

bill_mfv = Bill.new
def bill_mfv.hi 
  "Hi! I'm Bill."
end

bill_mfv.hi
```

```ruby
# Example 2: singleton class
class Bill
end

bill_mfv = Bill.new
class << bill_mfv
  def hi 
    "Hi! I'm Bill."
  end
end

bill_mfv.hi
```

```ruby
# Example 3:
class Bill
end

bill_mfv = Bill.new
bill_mfv.instance_eval do
  def hi
    "Hi! I'm Bill."
  end
end

bill_mfv.hi
```

```ruby
# Example 4:
class Bill
end

bill_mfv = Bill.new
bill_mfv.class.class_eval do
  def hi
    "Hi! I'm Bill."
  end
end

bill_mfv.hi
```

## Open to Change (Monkey patching)
You re-open any class and change it’s methods. You can add methods to classes, remove them or redefine them.
```ruby
class String
  # Simple method splits a sentence into an Array of words
  def words
    split(" ")
  end
end

"Hi! I'm Bill.".words #=> ["Hi!", "I'm", "Bill."]
"Hi!".words #=> ["Hi!"]
```

```ruby
class Integer
  alias_method :old_add, :+

  # Change behavior of +
  def +(num)
    old_add(num).old_add(1)
  end
end

1 + 1 #=> 3
4 + 8 #=> 13
```

```ruby
class Bill
  def hi
    "Hi! I'm Bill."
  end
end

bill_1 = Bill.new

class Bill
  remove_method :hi
end

bill_2 = Bill.new

bill_1.hi #=> NoMethodError
bill_2.hi #=> NoMethodError
```

## Writing Code That Writes Code
