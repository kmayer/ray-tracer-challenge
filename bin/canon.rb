#!/usr/bin/env ruby

require "bundler/setup"
require "ray_tracer"

module RT
  class Projectile
    attr_reader :position, :velocity
    def initialize(position, velocity)
      fail ArgumentError unless position.is_a?(Point)
      fail ArgumentError unless velocity.is_a?(Vector)
      @position = position # a Point
      @velocity = velocity # a Vector
      freeze
    end
  
    def tick(environment)
      new_position = position + velocity
      new_velocity = velocity + environment.gravity + environment.wind
      self.class.new(new_position, new_velocity)
    end
  end
  
  class Environment
    attr_reader :gravity, :wind
    def initialize(gravity, wind)
      fail ArgumentError unless gravity.is_a?(Vector)
      fail ArgumentError unless wind.is_a?(Vector)
      @gravity = gravity
      @wind = wind
      freeze
    end
  end
end

module RT
p0 = Projectile.new(Point[0,1,0], Vector[1, 1.8, 0].normalize * 11.25)
e = Environment.new(Vector[0, -0.1, 0], Vector[-0.01, 0, 0])
c = Canvas[900, 550];nil
background_color = Color[0.25, 0.25, 0.25]
mark = Color[1, 0 ,0]

c.pixels = background_color

p = p0
while p.position.y >= 0 do
  c.plot(p.position, mark)
  puts p.position.to_s
  p = p.tick(e)
end

File.open("artifacts//ch02-projectile.ppm", "w") {|f| f.write c.to_ppm }

system("open artifacts//ch02-projectile.ppm")
end