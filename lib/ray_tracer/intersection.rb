module RT
  class Intersection
    attr_reader :t, :object

    class << self
      def hit(intersections)
        intersections.filter(&:positive?).min
      end
    end

    def initialize(t, object)
      @t = t
      @object = object
      freeze
    end

    def positive?
      t.positive?
    end

    def <=>(other)
      t <=> other.t
    end
  end
end