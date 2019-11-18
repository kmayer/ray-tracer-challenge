module RT
  class Material
    attr_accessor :color, :ambient, :diffuse, :specular, :shininess, :reflective, :transparency, :refractive_index

    def initialize
      @color            = RT::WHITE
      @ambient          = 0.1
      @diffuse          = 0.9
      @specular         = 0.9
      @shininess        = 200.0
      @reflective       = 0.0
      @transparency     = 0.0
      @refractive_index = 1.0
    end

    def lighting(light, point, eyev, normalv)
      effective_color  = color.blend(light.intensity)
      lightv           = (light.position - point).to_vector.normalize
      light_dot_normal = lightv.dot(normalv)

      [
        ambient_contribution(effective_color),
        diffuse_contribution(light_dot_normal, effective_color),
        specular_contribution(eyev, light, light_dot_normal, lightv, normalv)
      ].reduce(:+)
    end

    private

    def ambient_contribution(effective_color)
      effective_color * ambient
    end

    def diffuse_contribution(light_dot_normal, effective_color)
      if light_dot_normal < 0
        RT::BLACK
      else
        effective_color * diffuse * light_dot_normal
      end
    end

    def specular_contribution(eyev, light, light_dot_normal, lightv, normalv)
      if light_dot_normal < 0
        RT::BLACK
      else
        reflectv        = (-lightv).reflect(normalv)
        reflect_dot_eye = reflectv.dot(eyev)

        if reflect_dot_eye <= 0
          RT::BLACK
        else
          factor = reflect_dot_eye ** shininess
          light.intensity * specular * factor
        end
      end
    end
  end
end
