require "ray_tracer/intersection"

ParameterType(
  name: 'intersection_attr',
  regexp: /t|object/,
  transformer: -> (match) { match },
  use_for_snippets: false
)

When('{var} ← intersection\({number}, {tvar})') do |i, number, sphere|
  instance_variable_set(i, RT::Intersection.new(number, instance_variable_get(sphere)))
end

Then("{var}.{intersection_attr} = {number}") do |i, attr, number|
  expect(instance_variable_get(i).public_send(attr)).to eq(number)
end

Then("{var}.{intersection_attr} = {tvar}") do |i, attr, sphere|
  expect(instance_variable_get(i).public_send(attr)).to eq(instance_variable_get(sphere))
end

When('{var} ← intersections\({tvar}, {tvar})') do |var, int, int2|
  instance_variable_set(var, [instance_variable_get(int), instance_variable_get(int2)])
end

Then("{var}[{int}].{intersection_attr} = {number}") do |var, int, attr, number|
  expect(instance_variable_get(var)[int].public_send(attr)).to eq(number)
end

When('{var} ← hit\({var})') do |i, xs|
  instance_variable_set(i, RT::Intersection.hit?(instance_variable_get(xs)))
end

Then("{var} is nothing") do |i|
  expect(instance_variable_get(i)).to be_nil
end


And('{var} ← intersections\({var}, {var}, {var}, {var})') do |xs, i1, i2, i3, i4|
  instance_variable_set(xs, [
    instance_variable_get(i1),
    instance_variable_get(i2),
    instance_variable_get(i3),
    instance_variable_get(i4)
  ])
end
