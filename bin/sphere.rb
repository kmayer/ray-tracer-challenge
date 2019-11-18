#!/usr/bin/env ruby

require "bundler/setup"
require "ray_tracer"
require 'benchmark/ips'

SPINNER = '+/-\|/-\\'.split("").cycle

module RT
  module_function

  def render_sphere_ch06
    light_source = RT::Light.new(RT::Point[10, 10, -10], Color[1.0, 0.2, 1.0])
    canvas = Canvas.new(200, 200, default_color: RT::Color[0.25, 0.25, 0.25])
    sphere = Sphere.new

    canvas.iterator do |x, y|
      world_point = RT::Point[(x - 100).to_f, (y - 150).to_f, 80.0]
      light_vector = (world_point - light_source.position).to_vector
      ray = RT::Ray.new(light_source.position, light_vector.normalize)
      xs = sphere.intersect(ray)

      if RT::Intersection.hit?(xs)
        putc SPINNER.next
        putc 0x08
        hit = RT::Intersection.hit(xs)
        point = ray.position(hit.t)
        normalv = hit.object.normal_at(point) # hit.object == sphere
        eyev = -ray.direction
        color = hit.object.material.lighting(light_source, point, eyev, normalv)
        canvas[x + 75, y] = color
      else
        #canvas[x + 75, 150 - y] = RT::WHITE
      end
    end

    return canvas
  end
end

c = RT.render_sphere_ch06
file = "artifacts/ch06-sphere.ppm"
File.open(file, "w") { |f| f.write c.to_ppm(4096.0) }
system("open", file)

#Benchmark.ips do |bm|
#  bm.config(time: 15, warmup: 2)
#  bm.report("render") { RT.render_circle_ch05}
#end
#
