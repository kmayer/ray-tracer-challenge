module RT
class Canvas
  class << self
    def [](width, height)
      new(width, height)
    end
  end

  attr_reader :width, :height
  def initialize(width, height, canvas: Array.new(height) { Array.new(width) }, default_color: RT::BLACK)
    @width = Integer(width)
    @height = Integer(height)
    @canvas = canvas
    @default_color = default_color
    freeze
  end

  def [](col, row)
    @canvas.fetch(row).fetch(col) || @default_color
  end

  def []=(col, row, value)
    @canvas.fetch(row)[col] = value.dup
  rescue => e
    warn "Skipped [#{col}, #{row}], #{e.message}"
  end

  def plot(point, color)
    x = point.x.to_i
    y = (height - 1) - point.y.to_i
    self[x, y] = color
  end

  def iterator
    (0...height).each do |row|
      (0...width).each do |col|
        yield col, row
      end
    end
  end

  def pixels
    return to_enum(__method__) unless block_given?

    iterator do |col, row|
      yield self[col, row]
    end
  end

  def pixels=(color)
    iterator do |col, row|
      @canvas.fetch(row)[col] = color.dup
    end
  end

  PORTABLE_PIXMAP_MAGIC_NUMBER = "P3"

  def to_ppm(color_max = 255)
    String.new.tap do |buffer|
      buffer << PORTABLE_PIXMAP_MAGIC_NUMBER << "\n"
      buffer << "#{width} #{height}" << "\n"
      buffer << "#{color_max}" << "\n"
      (0...height).each do |row|
        color_values =
          @canvas
            .fetch(row)
            .map{ |pixel| (pixel || @default_color).scale(color_max) }
            .map(&:to_rgb)
        line = color_values.join(" ")
        buffer << line_wrap(line) << "\n"
      end
    end
  end

  private

  # cribbed from https://apidock.com/rails/ActionView/Helpers/TextHelper/word_wrap
  def line_wrap(line, line_width: 70, break_sequence: "\n")
    (line.length > line_width) ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1#{break_sequence}").strip : line
  end
end
end
