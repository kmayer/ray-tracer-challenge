module RT
  # Value class for holding where a ray intersects with an object.
  # “Why t? Blame the mathematicians! It stands for time, which only makes sense once you think of the ray’s
  # direction vector as its speed. For example, if the ray moves one unit every second, then the following
  # figure from ​Scalar Multiplication and Division​, shows how far the ray travels in 3.5 seconds.”
  #
  # Excerpt From: Jamis Buck. “The Ray Tracer Challenge (for Ken Mayer).” Apple Books.
  Intersection = Struct.new(:t, :object) do
    def initialize(*)
      super
      freeze
    end

    def positive?
      t.positive?
    end

    def <=>(other)
      t <=> other.t
    end

    def self.hit(intersections)
      intersections.filter(&:positive?).min
    end

    def self.hit?(intersections)
      hit(intersections)
    end
  end
end
