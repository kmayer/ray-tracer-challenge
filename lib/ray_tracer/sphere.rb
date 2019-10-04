module RT
  class Sphere
    attr_reader :origin
    attr_accessor :transform

    def initialize(origin: RT::Point[0, 0, 0], transform: RT::Matrix.identity(4))
      @origin = origin
      @transform = transform
      # NOT frozen because :transform can be modified
    end

    def intersect(ray)
      transformed_ray = ray.transform(transform.inverse)
      a, b, discriminant = calc_discriminant(transformed_ray)

      if discriminant < 0
        []
      else
        t1 = (-b - Math.sqrt(discriminant)) / (2.0 * a)
        t2 = (-b + Math.sqrt(discriminant)) / (2.0 * a)

        [t1, t2].sort.map { |t| RT::Intersection.new(t, self) }
      end
    end

    private

    def calc_discriminant(ray)
      sphere_to_ray = ray.origin - origin
      a             = ray.direction.dot(ray.direction)
      b             = 2.0 * ray.direction.dot(sphere_to_ray)
      c             = sphere_to_ray.dot(sphere_to_ray) - 1.0

      discriminant = b ** 2 - 4 * a * c

      [a, b, discriminant]
    end
  end
end
