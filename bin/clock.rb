#!/usr/bin/env ruby

require "bundler/setup"
require "ray_tracer"
require 'benchmark/ips'

module RT
  module_function

  NOON = Point[0, 1, 0]
  PLOT_COLOR = Color[1, 1, 1] # "white"

  def render_clock_ch04
    c = Canvas[500, 500]

    (0..11).each do |hour|
      transform = Matrix
                      .rotation_z((hour / 12.0) * (2 * Math::PI))
                      .scale(200, 200, 0)
                      .translate(250, 250, 0)

      c.plot(transform.(NOON), PLOT_COLOR)
    end
    return c
  end
end

Benchmark.ips do |bm|
  bm.config(time: 15, warmup: 2)
  bm.report("render") { RT.render_clock_ch04 }
end

c = RT.render_clock_ch04
file = "artifacts/ch04-clock.ppm"
File.open(file, "w") { |f| f.write c.to_ppm }
system("open", file)
