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

Then("{var}.transform = identity_matrix") do |var|
  expect(instance_variable_get(var).transform).to eq(RT::Matrix.identity(4))
end

Then("{var}.transform = {var}") do |sphere, transform|
  expect(instance_variable_get(sphere).transform).to eq(instance_variable_get(transform))
end

When('set_transform\({var}, {var})') do |sphere, transform|
  instance_variable_get(sphere).transform = instance_variable_get(transform)
end

When('{var}.transform = {transform}\({number}, {number}, {number})') do |sphere, transform, number, number2, number3|
  instance_variable_get(sphere).transform = RT::Matrix.public_send(transform, number, number2, number3)
end
