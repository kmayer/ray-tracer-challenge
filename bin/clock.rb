#!/usr/bin/env ruby

require "bundler/setup"
require "ray_tracer"

module RT
  c = Canvas[500, 500];nil

  NOON = Point[0, 1, 0]
  point = NOON.dup # "Noon"

  one_twelfth_rotation = RT::Matrix.rotation_z((2 * Math::PI) / 12)
  scale = RT::Matrix.scaling(200, 200, 0)
  translate = RT::Matrix.translation(250, 250, 0)

  plot_color = Color[1, 1, 1] # "white"

  (0..11).each do
    plot_point = scale * point
    plot_point = translate * plot_point
    c.plot(plot_point, plot_color)
    point = one_twelfth_rotation * point
  end

  file = "artifacts/ch04-clock.ppm"
  File.open(file, "w") { |f| f.write c.to_ppm }
  system("open",file)
end