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
# Example 5:
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
# Example 6:
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
# Example 7:
class Bill
  def hi
    "Hi! I'm Bill."
  end
end

class BillMfv < Bill
  def hi
    "Hi! I'm Bill from MFV."
  end
end

class BillMfj < Bill
  def hi
    "Hi! I'm Bill from MFJ."
  end
end

class BillMfv
  undef_method :hi
end


class BillMfj
  remove_method :hi
end

bill_mfv = BillMfv.new
bill_mfv.hi #=> NoMethodError

bill_mfj = BillMfj.new
bill_mfj.hi #=> "Hi! I'm Bill."
```

Noted:
- `undef_method` will make the method becomes not defined -> will raise `NoMethodError` if we call this method.
- `remove_method` will remove the method only in the class, but doesn't remove the method in parent classes.

## Writing Code That Writes Code
Writing code that is the same (or similar) several times -> waste of time and maybe hard to make changes in future
=> Don't Repeat Yourself (DRY)
It’s possible to remove this duplication of effort by writing code that writes the code for you.
`define_method`
```ruby
# Example 8:

```


## send
## method_missing

