require "ray_tracer/material"

ParameterType(
  name: 'material_attr',
  regexp: /color|ambient|diffuse|specular|shininess|reflective|transparency|refractive_index/,
  transformer: -> (match) { match },
  use_for_snippets: false
)

Given('{var} ← material') do |m|
  instance_variable_set(m, RT::Material.new)
end

Then('{var}.{material_attr} = {color}') do |var, attr, color|
  expect(instance_variable_get(var).public_send(attr)).to eq(color)
end

Then('{var}.{material_attr} = {float}') do |var, attr, float|
  expect(instance_variable_get(var).public_send(attr)).to eq(float)
end

When('result ← lighting\(m, light, position, eyev, normalv)') do
  instance_variable_set(:@result, @m.lighting(@light, @position, @eyev, @normalv))
end

Then("result = {color}") do |color|
  expect(instance_variable_get(:@result)).to be_within(EPSILON_TUPLE).of(color)
end
