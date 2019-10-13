require "ray_tracer/ray"

ParameterType(
  name: 'ray_attr',
  regexp: /origin|direction/,
  transformer: ->(match) { match },
  use_for_snippets: false
)

When('{var} ← ray\({tvar}, {tvar})') do |ray, origin, direction|
  instance_variable_set(ray, RT::Ray.new(instance_variable_get(origin), instance_variable_get(direction)))
end

Then("{var}.{ray_attr} = {tvar}") do |ray, attr, tuple|
  expect(instance_variable_get(ray).public_send(attr)).to eq(instance_variable_get(tuple))
end

Then("{var}.{ray_attr} = {pvc}") do |ray, attr, point|
  expect(instance_variable_get(ray).public_send(attr)).to eq(point)
end

Given('{var} ← ray\({pvc}, {pvc})') do |ray, point, vector|
  instance_variable_set(ray, RT::Ray.new(point, vector))
end

Then('position\({var}, {number}) = {pvc}') do |ray, t, point|
  expect(instance_variable_get(ray).public_send(:position, t)).to eq(point)
end

When('{var} ← transform\({var}, {var})') do |r2, r, m|
  instance_variable_set(r2, instance_variable_get(r).transform(instance_variable_get(m)))
end

