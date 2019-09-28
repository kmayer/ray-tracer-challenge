require 'ice_nine'
require 'ice_nine/core_ext/object'

module RT
  class Matrix
    class << self
      include Math
      private :new
    
      def build(height, width, &block)
        new(height, width, &block)
      end

      def[](*data)
        cols = data.first.length
        rows = data.length
        new(rows, cols) { |row, col| data[row][col] }
      end

      def identity(n = 4)
        build(n,n) { |i,j| i == j ? 1 : 0 }
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
        build(4,4) { |i,j| matrix.fetch(i).fetch(j) }
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
        build(4,4) { |i,j| matrix.fetch(i).fetch(j) }
      end

      def rotation_x(r)
        matrix =
        [
          [1,      0,       0, 0],
          [0, cos(r), -sin(r), 0],
          [0, sin(r),  cos(r), 0],
          [0,      0,       0, 1],
        ]
        build(4,4) { |i,j| matrix.fetch(i).fetch(j) }
      end

      def rotation_y(r)
        matrix =
        [
          [ cos(r), 0, sin(r), 0],
          [      0, 1,      0, 0],
          [-sin(r), 0, cos(r), 0],
          [      0, 0,      0, 1],
        ]
        build(4,4) { |i,j| matrix.fetch(i).fetch(j) }
      end

      def rotation_z(r)
        matrix =
        [
          [cos(r), -sin(r), 0, 0],
          [sin(r),  cos(r), 0, 0],
          [     0,       0, 1, 0],
          [     0,       0, 0, 1],
        ]
        build(4,4) { |i,j| matrix.fetch(i).fetch(j) }
      end

      def shearing(xy, xz, yx, yz, zx, zy)
        matrix = 
        [
          [1, xy, xz, 0],
          [yx, 1, yz, 0],
          [zx, zy, 1, 0],
          [ 0,  0, 0, 1]
        ]
        build(4,4) { |i,j| matrix.fetch(i).fetch(j) }      
      end
      alias_method :skew, :shearing
    end

    attr_reader :m, :height, :width
    def initialize(height, width, &block)
      @height = height
      @width = width
      @m = Array.new(height) { Array.new(width) { 0.0 } }

      (0...height).each do |row|
        (0...width).each do |col|
          @m[row][col] = yield row, col
        end
      end
      deep_freeze
    end
    alias_method :row_count, :height

    def inspect
      "#{self.class}#{m}"
    end

    def to_s
      inspect
    end

    def pretty(f = "% 9.5f")
      rows.map do |r|
        " | " << r.to_a.map {|v| format(f, v)}.join(" | ") << " | "
      end.join("\n")
    end

    def size
      return height if height == width
    end

    def [](i, j)
      fail ArgumentError, [i, j] if i.negative? || j.negative?
      m.fetch(i).fetch(j)
    end

    def row(i)
      RT::Tuple.build(m.fetch(i))
    end

    def col(j)
      RT::Tuple.build(m.map { |r| r.fetch(j) })
    end

    def rows
      (0...height).map { |i| row(i) }
    end

    def cols
      (0...width).map { |j| col(j) }
    end

    def ==(other)
      iterator.all? { |value,row,col| value == other[row,col] }
    end

    def <=(other)
      iterator.all? { |value,row,col| value <= other[row,col] }
    end

    def *(other)
      case other
      when RT::Matrix
        self.class.build(height, width) { |i,j| row(i).dot(other.col(j)) }
      when RT::Tuple
        other.class.build((0...size).map { |i| row(i).dot(other) })
      else
        fail ArgumentError, other.inspect
      end
    end
    # Allows creating a matrix named "transform" and then writing code:
    # transform.(<Tuple>) => <Tuple>
    alias_method :call, :*

    def +(other)
      self.class.build(height, width) { |i,j| self[i,j] + other[i,j] }
    end

    def -(other)
      self.class.build(height, width) { |i,j| self[i,j] - other[i,j] }
    end

    def abs
      self.class.build(height, width) { |i,j| self[i,j].abs }
    end

    def transpose
      self.class.build(width, height) { |i,j| self[j, i] }
    end

    def determinant
      det = 0
      if size == 2
        det = self[0,0] * self[1,1] - self[1,0] * self[0,1]
      else
        row(0).each.with_index { |x, j| det += x * cofactor(0, j)}
      end
      det
    end

    def first_minor(xrow, xcol)
      sub = m.map.with_index { |r, i| next if i == xrow; r.map.with_index {|c, j| next if j == xcol; c }.compact }.compact
      self.class.build(height - 1, width - 1) { |i,j| sub[i][j] }
    end
    alias_method :submatrix, :first_minor

    def minor(xrow, xcol)
      first_minor(xrow, xcol).determinant
    end

    def cofactor(row, col)
      minor(row,col).public_send((row + col).odd? ? :-@ : :itself)
    end

    def invertible?
      !determinant.zero?
    end

    def inverse
      fail if !invertible?
      det = determinant
      self.class.build(height, width) { |j, i| cofactor(i,j) / det }
    end
    alias_method :invert, :inverse

    # Fluent interface
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

    private

    def iterator
      return to_enum(__method__) unless block_given?

      (0...height).each do |row|
        (0...width).each do |col|
          yield self[row,col], row, col
        end
      end
    end
  end
end