require "canvas"

ParameterType(
  name: 'canvas_attr',
  regexp: /height|width/,
  transformer: -> (match) { match }
)

ParameterType(
  name: 'canvas_method',
  regexp: /to_ppm/,
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

Then("{varname}[{int}, {int}] is {varname}") do |canvas, col, row, color|
  expect(instance_variable_get(canvas)[col, row]).to eq(instance_variable_get(color))
end

Then("{varname} = {varname}") do |var, var2|
  expect(instance_variable_get(var)).to eq(instance_variable_get(var2))
end

When("{varname} ← {varname}.{canvas_method}") do |var, canvas, method|
  instance_variable_set(var, instance_variable_get(canvas).public_send(method))
end

Then("lines {int}-{int} of {varname} are") do |l0, l1, var, string|
  l0 -= 1
  l1 -= 1
  lines = instance_variable_get(var).split("\n")
  expect(lines[l0..l1].join("\n")).to eq(string)
end

When("every pixel of {varname} is set to {color}") do |canvas, color|
  instance_variable_get(canvas).pixels=(color)  
end

Then("{varname} ends with a newline character") do |ppm|
  expect(instance_variable_get(ppm)[-1]).to eq("\n")
end