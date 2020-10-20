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

# Normal
class RestApi
  def perform_get path
    "You are perform GET " + path
  end
  
  def perform_post path
    "You are perform POST " + path
  end
  
  def perform_delete path
    "You are perform DELETE " + path
  end
end

# Using define_method
class RestApi
  ACTIONS = [:post, :get, :delete]

  ACTIONS.each do |action|
    define_method("perform_#{action}") do |path|
      "You are perform #{action.to_s.upcase} " + path
    end
  end
end

api = RestApi.new
api.perform_get("/api/users/1") #=> "You are perform GET /api/users/1"

api.perform_post("/api/users/1") #=> "You are perform POST /api/users/1"
```


## send
```ruby
def relay(array, data_type)
  array.map{|e| e.send("to_#{data_type}")}
end

relay([1,3,4], "s")
```
## method_missing
```ruby
def method_missing(method_name, *args, &block)
end
```

```ruby
class Presenter
  attr_accessor :object

  def initialize object
    @object = object
  end

  # If a method we call is missing, pass the call onto the object we delegate to.
  def method_missing method_name, *args, &block
    puts "Delegating #{method_name}"
    object.send(method_name, *args, &block)
  end
end

str_presenter = Presenter.new("I'm Bill.")
str_presenter.to_i
  # Delegating to_i
  # => 0

str_presenter.upcase
  # Delegating upcase
  # => "I'M BILL."

str_presenter.gsub("'m", " am")
  # Delegating gsub
  # => "I am Bill."

# But when we call the method respond_to? to check a method is in the object or not.
str_presenter.respond_to?(:upcase)
  # => false
```


https://www.leighhalliday.com/ruby-metaprogramming-method-missing
https://thoughtbot.com/blog/always-define-respond-to-missing-when-overriding
