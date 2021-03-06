require_relative "material"

module RT
  class Sphere
    attr_reader :origin
    attr_accessor :transform
    attr_reader :material

    def initialize(origin: RT::ORIGIN, transform: RT::Matrix.identity(4), material: RT::Material.new)
      @origin = origin
      @transform = transform
      @material = material
      # NOT frozen because :transform & :material can be modified
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

    def normal_at(point)
      object_point = transform.invert * point
      object_normal = object_point - RT::ORIGIN
      world_normal = transform.invert.transpose * object_normal
      world_normal = world_normal.to_vector
      world_normal.normalize
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
