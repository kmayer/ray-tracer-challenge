#!/usr/bin/env ruby

require "bundler/setup"
require "ray_tracer"
require 'benchmark/ips'

# project a ray at a unit sphere and render the projection

module RT
  module_function

  def render_circle_ch05
    light_source = RT::Point[0, 0, -2]
    canvas = Canvas.new(300, 300)
    sphere = Sphere.new(transform: RT::Matrix.scaling(1, 0.25, 1))
    red = RT::Color[1, 0, 0]

    z = 100 # The farther away, the bigger the projection
    canvas.iterator do |x, y|
      point = RT::Point[x - 100, y - 100, 150]
      light_vector = (point - light_source)
      ray = RT::Ray.new(light_source, light_vector)

      canvas[x + 50, y + 50] = red if RT::Intersection.hit?(sphere.intersect(ray))
    end

    return canvas
  end
end

c = RT.render_circle_ch05
file = "artifacts/ch05-circle.ppm"
File.open(file, "w") { |f| f.write c.to_ppm }
system("open", file)

Benchmark.ips do |bm|
  bm.config(time: 15, warmup: 2)
  bm.report("render") { RT.render_circle_ch05}
end

