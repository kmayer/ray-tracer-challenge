module RT
  class Sphere
    attr_reader :origin

    def initialize
      @origin = RT::Point[0, 0, 0]
      freeze
    end

    def intersect(ray)
      a, b, discriminant = calc_discriminant(ray)

      if discriminant < 0
        []
      else
        t1 = (-b - Math.sqrt(discriminant)) / (2 * a)
        t2 = (-b + Math.sqrt(discriminant)) / (2 * a)

        [t1, t2].sort.map { |t| RT::Intersection.new(t, self) }
      end

    end

    private

    def calc_discriminant(ray)
      sphere_to_ray = ray.origin - origin
      a             = ray.direction.dot(ray.direction)
      b             = 2 * ray.direction.dot(sphere_to_ray)
      c             = sphere_to_ray.dot(sphere_to_ray) - 1

      discriminant = b ** 2 - 4 * a * c

      [a, b, discriminant]
    end
  end
end