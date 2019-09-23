require "matrix"

module RT
class Tuple < ::Vector
  class << self
    def [](x,y,z,w)
      build([x,y,z,w])
    end

    def build(array)
      elements(array.map{ |i| Float(i) })
    end
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
    w == 0
  end

  def abs
    self.class.build(to_a.map(&:abs))
  end

  def normalize
    self / magnitude
  end

  def <=(other)
    x <= other.x && y <= other.y && z <= other.z && w <= other.w
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

  def to_v
    ::Vector.elements(first(3))
  end

  def cross(other)
    self.class.build(to_v.cross(other.to_v).to_a << 0)
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
end