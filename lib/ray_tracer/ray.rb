module RT
  class Ray
    attr_reader :origin, :direction

    def initialize(origin, direction)
      @origin    = origin
      @direction = direction
      freeze
    end

    def position(t) # t for "time"
      origin + (direction * t)
    end
  end
end