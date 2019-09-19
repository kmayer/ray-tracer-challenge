#!/usr/bin/env ruby

require "bundler/setup"
require "ray_tracer"

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

p0 = Projectile.new(Point[0,1,0], Vector[1, 1.8, 0].normalize * 11.25)
e = Environment.new(Vector[0, -0.1, 0], Vector[-0.01, 0, 0])
c = Canvas[900, 550];nil
mark = Color[1, 0 ,0]

p = p0
while p.position.y >= 0 do
  x = p.position.x.to_i
  y = 550 - p.position.y.to_i
  c[x, y] = mark
  puts [x, y].to_s
  p = p.tick(e)
end

File.open("/tmp/bang.ppm", "w") {|f| f.write c.to_ppm }

system("open /tmp/bang.ppm")