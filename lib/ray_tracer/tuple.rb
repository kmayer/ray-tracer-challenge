require "matrix" # Native ::Matrix class

module RT
class Tuple < ::Vector
  class << self
    def [](x,y,z,w)
      build([x,y,z,w])
    end

    def build(array)
      elements(array.map { |i| Rational(i) }).freeze
    end
  end

  # Override because the ::Vector class hardwires the class name in #inspect
  def inspect
    "#{self.class}#{to_a}"
  end

  def to_s
    inspect
  end

  def x; element(0); end
  def y; element(1); end
  def z; element(2); end
  def w; element(3); end
  def fetch(i); element(i); end

  # unary operators
  def point?
    w == 1
  end

  def vector?
    w.zero?
  end

  def abs
    collect(&:abs)
  end

  def <=(other)
    x <= other.x && y <= other.y && z <= other.z && w <= other.w
  end

  def normalize
    self / magnitude
  end

  def to_vector
    RT::Vector[x,y,z]
  end
end

class Point < Tuple
  class << self
    def [](x,y,z)
      build([x,y,z,1])
    end
  end
end

class Vector < Tuple
  class << self
    def [](x,y,z)
      build([x,y,z,0])
    end
  end

  # The cross product of our vectors is only the first 3 elements
  # The fourth element indicates point/vector identity, but also
  # because the math works out that way. Using ::Vector's native
  # #cross method breaks because of the fourth element.
  def to_v
    ::Vector[x, y, z]
  end

  def cross(other)
    self.class.build(to_v.cross(other.to_v).to_a << 0)
  end

  def reflect(normal)
    self - normal * 2 * self.dot(normal)
  end
end

class Color < Vector
  alias_method :red, :x
  alias_method :green, :y
  alias_method :blue, :z

  def to_rgb
    [red, green, blue].map(&:to_i)
  end

  # Color blending
  def blend(other)
    fail ArgumentError, other unless other.is_a?(Color)
    self.class[red * other.red, green * other.green, blue * other.blue]
  end

  # Scale the color values to a maximum value
  def scale(clamp_max)
    self.class[
      *[red, green, blue]
        .map { |rgb| rgb * clamp_max }
        .map { |rgb| rgb.clamp(0, clamp_max) }
        .map { |rgb| rgb.round(0, half: :even) }
    ]
  end
end
  ORIGIN = RT::Point[0,0,0]
end
