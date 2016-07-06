# ----- 1. Object Oriented ----- #
class Rectangle
  def initialize(length, breadth)
    @length = length
    @breadth = breadth
  end

  # Getters and Setters
  def length()
    @length
  end

  def breadth()
    @breadth
  end

  def length=(new_length)
    @length = new_length
  end

  def breadth=(new_breadth)
    @breadth = new_breadth
  end

  def area()
    @length * @breadth
  end


  def to_s
    "#{@length}X#{@breadth} rectangle"
  end
end

# Create new rectangle. Observe that `new` is a method.
r = Rectangle.new(2,3)
puts r.area()
r.length=4
puts r.area()

# `to_s` is inherited from the Object class
puts "#{r.to_s}"
# Ofcouse, it can be overridden

# ----- 2. All data are objects  ----- #

def print_this_object(obj)
  fail "Not an object!" unless obj.is_a? Object
  puts "#{obj.to_s}"
end

print_this_object(r)
print_this_object(2)
print_this_object(Rectangle)
print_this_object(Class)
print_this_object(r.method :area) # :area denotes a symbol of name "area"

# Inheritance hierarchy: http://i.stack.imgur.com/rvcEi.png

# ----- 3. Dynamic Nature  ----- #
# The definition of a class, a method in the class, or
# even the methods an object responds_to can be changed
# at run-time
puts r.to_s()
class Rectangle
  def to_s()
    "A rectangle of dimensions #{length()}X#{breadth()}"
  end
end
puts r.to_s()

# Singleton methods
puts r.respond_to? :perimeter
def r.perimeter()
  length() + breadth()
end
puts r.respond_to? :perimeter
puts (Rectangle.new(4,5)).respond_to? :perimeter

def override_to_s(cls)
  cls.class_eval do
    define_method(:to_s, Proc.new {"Hello World!"})
  end
end
puts r.to_s()
override_to_s(Rectangle)
puts r.to_s()

# ----- 4. (Almost) All control-flow is via methods ----- #

# We have already seen the assignment example:
r.breadth = 5 # will call the `breadth=` method on r.

puts 2+3 # will call the plus method on 2.

class Fixnum
  # backup the real plus method
  alias_method(:real_plus, :+)
  def +(other)
    other*other
  end
end

puts 2+3

# In the similar way, the definitions of all equalities and
# inequalities are user-controlled.

# Now restore the real plus method
class Fixnum
  def +(other)
    real_plus(other)
  end
end

# If I implement all integer operations in a class, for all
# practical purposes, it is an integer.
class Rectangle
  def +(x)
    Rectangle.new(length()+x,breadth()+x)
  end
  # restoring the to_s definition
  def to_s()
    "A rectangle of dimensions #{length()}X#{breadth()}"
  end
end
s = Rectangle.new(7,8)
puts s.to_s()
puts (s+2).to_s()

# ----- 4. Meta-programming is used heavily in Ruby to ease programming ------ #

# The most common use is to automatically define getters and setters.
class RectangleV2
  # attr_accessor is a meta function defined by ruby that adds
  # getters and setters for variables of given names to the
  # current class.
  attr_accessor(:length, :breadth)
  def initialize(l,b)
    length = l
    breadth = b
  end
end