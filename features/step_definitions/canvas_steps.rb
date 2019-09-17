require "canvas"

ParameterType(
  name: 'canvas_attr',
  regexp: /height|width/,
  transformer: -> (match) { match }
)

Given("{varname} ← Canvas[{int}, {int}]") do |var, int, int2|
  instance_variable_set(var, Canvas[int, int2])
end

Then("{varname}.{canvas_attr} = {int}") do |canvas, attr, value|
  expect(instance_variable_get(canvas).public_send(attr)).to eq value
end

Then("every pixel of {varname} is {color}") do |canvas, color|
  expect(instance_variable_get(canvas).pixels.all? { |p| p == color }).to eq(true)
end

When("{varname}[{int}, {int}] = {varname}") do |canvas, row, col, color|
  instance_variable_get(canvas)[row, col] = instance_variable_get(color)
end

Then("{varname}[{int}, {int}] is {varname}") do |canvas, row, col, color|
  expect(instance_variable_get(canvas)[row, col]).to eq(instance_variable_get(color))
end

Then("{varname} = {varname}") do |var, var2|
  expect(instance_variable_get(var)).to eq(instance_variable_get(var2))
end