class Canvas
  class << self
    def [](width, height)
      new(width, height)
    end
  end

  attr_reader :width, :height
  def initialize(width, height, canvas = Array.new(height) { Array.new(width) { Color[0,0,0] } })
    @width = width
    @height = height
    @canvas = canvas
    freeze
  end

  def pixels
    return to_enum(__method__) unless block_given?

    (0...height).each do |row|
      (0...width).each do |col|
        yield @canvas.fetch(row).fetch(col)
      end
    end
  end

  def [](row, col)
    @canvas.fetch(row).fetch(col)
  end

  def []=(row, col, value)
    @canvas.fetch(row)[col] = value.dup
  end
end