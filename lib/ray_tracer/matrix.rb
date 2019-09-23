module RT
  class Matrix
    class << self
      private :new
    
      def build(height, width, &block)
        new(height, width, &block)
      end

      def[](*data)
        cols = data.first.length
        rows = data.length
        new(rows, cols) { |row, col| data[row][col] }
      end

      def identity(n)
        build(n,n) { |i,j| i == j ? 1 : 0 }
      end
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
    end
    alias_method :row_count, :height

    def size
      return height if height == width
    end

    def [](i, j)
      m.fetch(i).fetch(j)
    end

    def row(i)
      RT::Tuple.build(m.fetch(i))
    end

    def col(j)
      RT::Tuple.build(m.map {|r| r.fetch(j) })
    end

    def rows
      (0...height).map {|i| row(i) }
    end

    def cols
      (0...width).map {|j| col(j)}
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
        RT::Tuple.build((0...height).map { |i| row(i).dot(other) })
      end
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