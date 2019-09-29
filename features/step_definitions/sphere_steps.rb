require "ray_tracer/sphere"

Given('{var} ← sphere') do |sphere|
  instance_variable_set(sphere, RT::Sphere.new)
end

When('{var} ← intersect\({var}, {var})') do |xs, sphere, ray|
  instance_variable_set(xs, instance_variable_get(sphere).intersect(instance_variable_get(ray)))
end

Then("{var}.count = {int}") do |xs, int|
  expect(instance_variable_get(xs).count).to eq(int)
end

Then("{var}[{int}] = {number}") do |xs, int, number|
  expect(instance_variable_get(xs)[int]).to eq(number)
end

Then("{var}[{int}].{intersection_attr} = {var}") do |var, int, attr, var2|
  expect(instance_variable_get(var)[int].public_send(attr)).to eq(instance_variable_get(var2))
end