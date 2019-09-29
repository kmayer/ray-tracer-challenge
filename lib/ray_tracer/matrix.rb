require 'ice_nine'
require 'ice_nine/core_ext/object'
require "matrix"

module RT
  class Matrix < ::Matrix
    class << self
      include Math

      def initialize(*)
        super
        deep_freeze
      end

      # Build a translation matrix by first building an identity matrix
      # then composing (adding) the translation vector to the last column
      def translation(x, y, z)
        matrix = 
        [
          [1, 0, 0, x],
          [0, 1, 0, y],
          [0, 0, 1, z],
          [0, 0, 0, 1]
        ]
        build(4, 4) { |i, j| matrix.dig(i, j) }
      end

      # Build a scaling matrix by placing the scaling vector along the diagonal
      def scaling(x, y, z)
        matrix = 
        [
          [x, 0, 0, 0],
          [0, y, 0, 0],
          [0, 0, z, 0],
          [0, 0, 0, 1]
        ]
        build(4, 4) { |i, j| matrix.dig(i, j) }
      end

      def rotation_x(r)
        matrix =
        [
          [1,      0,       0, 0],
          [0, cos(r), -sin(r), 0],
          [0, sin(r),  cos(r), 0],
          [0,      0,       0, 1],
        ]
        build(4, 4) { |i, j| matrix.dig(i, j) }
      end

      def rotation_y(r)
        matrix =
        [
          [ cos(r), 0, sin(r), 0],
          [      0, 1,      0, 0],
          [-sin(r), 0, cos(r), 0],
          [      0, 0,      0, 1],
        ]
        build(4, 4) { |i, j| matrix.dig(i, j) }
      end

      def rotation_z(r)
        matrix =
        [
          [cos(r), -sin(r), 0, 0],
          [sin(r),  cos(r), 0, 0],
          [     0,       0, 1, 0],
          [     0,       0, 0, 1],
        ]
        build(4, 4) { |i, j| matrix.dig(i, j) }
      end

      def shearing(xy, xz, yx, yz, zx, zy)
        matrix = 
        [
          [1, xy, xz, 0],
          [yx, 1, yz, 0],
          [zx, zy, 1, 0],
          [ 0,  0, 0, 1]
        ]
        build(4, 4) { |i, j| matrix.dig(i, j) }
      end
      alias_method :skew, :shearing
    end

    def pretty(f = "% 9.5f")
      rows.map do |r|
        " | " << r.to_a.map {|v| format(f, v)}.join(" | ") << " | "
      end.join("\n")
    end

    def <=(other)
      each_with_index.all? { |value,row,col| value <= other[row,col] }
    end

    def abs
      collect(&:abs)
    end

    def *(other)
      product = super
      if product.is_a?(::Vector) && product.size == 4
        product[3].zero? ? RT::Vector.build(product.to_a) : RT::Point.build(product.to_a)
      else
        product
      end
    end

    alias_method :submatrix, :first_minor

    # This overrides Matrix#minor which is a generalized form of #first_minor
    # A "better" name would be det_of_first_minor, but :shrug:
    def minor(xrow, xcol)
      first_minor(xrow, xcol).determinant
    end

    def invertible?
      !determinant.zero?
    end

    alias_method :invert, :inverse

    # Fluent interface
    alias_method :call, :*

    def translate(x, y, z)
      self.class.translation(x, y, z) * self
    end

    def scale(x, y, z)
      self.class.scaling(x, y, z) * self
    end

    def rotate_x(r)
      self.class.rotation_x(r) * self
    end

    def rotate_y(r)
      self.class.rotation_y(r) * self
    end

    def rotate_z(r)
      self.class.rotation_z(r) * self
    end

    def shear(xy, xz, yx, yz, zx, zy)
      self.class.shearing(xy, xz, yx, yz, zx, zy) * self
    end
  end
end