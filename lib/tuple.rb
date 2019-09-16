class Tuple
  class << self
    def [](x,y,z,w)
      new(x,y,z,w)
    end
  end

  attr_reader :x,:y,:z,:w
  def initialize(x,y,z,w)
    @x = Float(x)
    @y = Float(y)
    @z = Float(z)
    @w = Float(w)
    freeze
  end

  # unary operators
  def point?
    w == 1
  end

  def vector?
    w == 0
  end

  def ==(other)
    x == Float(other.x) && y == Float(other.y) && z == Float(other.z) && w == other.w
  end

  def -@
    self.class.new(-x, -y, -z, -w)
  end

  def abs
    self.class.new(x.abs, y.abs, z.abs, w.abs)
  end

  def magnitude
    Math.sqrt(x**2 + y**2 + z**2)
  end

  def normalize
    self / magnitude
  end

  # inline operators
  def +(other)
    self.class.new(x + other.x, y + other.y, z + other.z, w + other.w)
  end

  def -(other)
    self.class.new(x - other.x, y - other.y, z - other.z, w - other.w)
  end

  def *(scalar)
    self.class.new(x * scalar, y * scalar, z * scalar, w * scalar)
  end

  def /(scalar)
    self.class.new(x / scalar, y / scalar, z / scalar, w / scalar)
  end

  # other methods
  def dot(other)
    x * other.x + y * other.y + z * other.z + w * other.w
  end

  # comparators
  def <=(other)
    x <= other.x && y <= other.y && z <= other.z && w <= other.w
  end
end

class Point < Tuple
  class << self
    def [](x,y,z)
      new(x,y,z)
    end
  end

  def initialize(x, y, z, w = 1)
    super
  end
end

class Vector < Tuple
  class << self
    def [](x,y,z)
      new(x,y,z)
    end
  end

  def initialize(x, y, z, w = 0)
    super
  end

  def cross(other)
    self.class.new(y * other.z - z * other.y, z * other.x - x * other.z, x * other.y - y * other.x)
  end
end

class Color < Tuple
  class << self
    def [](x,y,z)
      new(x,y,z)
    end
  end

  def initialize(x, y, z, w = 0)
    super
  end

  alias_method :red, :x
  alias_method :green, :y
  alias_method :blue, :z
end
