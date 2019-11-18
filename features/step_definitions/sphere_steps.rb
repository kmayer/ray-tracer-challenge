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

When('{var} ← normal_at\({var}, {pvc})') do |normal_vector, sphere, point|
  instance_variable_set(normal_vector, instance_variable_get(sphere).normal_at(point))
end

When('{var} ← normal_at\({var}, {var})') do |normal_vector, sphere, point|
  instance_variable_set(normal_vector, instance_variable_get(sphere).normal_at(instance_variable_get(point)))
end

Given('{var} ← point\({rational}, {rational}, {rational})') do |var, x, y, z|
  instance_variable_set(var, RT::Point[x, y, z])
end

Given('{var} ← point\({number}, {rational}, {rational})') do |var, x, y, z|
  instance_variable_set(var, RT::Point[x, y, z])
end

Then('{var} = vector\({rational}, {rational}, {rational})') do |var, x, y, z|
  expect(instance_variable_get(var)).to be_within(EPSILON_TUPLE).of(RT::Vector[x, y, z])
end

Then('{var} = normalize\({var})') do |var, _same_var|
  expect(var).to eq(_same_var)
  n = instance_variable_get(var)
  expect(n).to eq(n.normalize)
end

Given('m ← {transform}\({number}, {number}, {number}) * {rotation}\(π\/{number})') do |transform, x, y, z, rotation, r|
  t1 = RT::Matrix.public_send(transform, x, y, z)
  t2 = RT::Matrix.public_send(rotation, r)
  instance_variable_set(:@m, t1 * t2)
end


