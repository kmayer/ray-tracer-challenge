#!/usr/bin/env ruby

require "bundler/setup"
require "ray_tracer"

module RT
  c = Canvas[500, 500]
  NOON = Point[0, 1, 0]
  PLOT_COLOR = Color[1, 1, 1] # "white"

  (0..11).each do |hour|
    transform = Matrix
                .rotation_z((hour / 12.0) * (2 * Math::PI))
                .scale(200, 200, 0)
                .translate(250, 250, 0)

    c.plot(transform.(NOON), PLOT_COLOR)
  end

  file = "artifacts/ch04-clock.ppm"
  File.open(file, "w") { |f| f.write c.to_ppm }
  system("open",file)
end