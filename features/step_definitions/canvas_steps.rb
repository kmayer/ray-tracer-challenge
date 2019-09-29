require "ray_tracer/canvas"

ParameterType(
  name: 'canvas_attr',
  regexp: /height|width/,
  transformer: -> (match) { match }
)

Given('{var} ← canvas\({int}, {int})') do |var, int, int2|
  instance_variable_set(var, RT::Canvas[int, int2])
end

Then("{var}.{canvas_attr} = {int}") do |canvas, attr, value|
  expect(instance_variable_get(canvas).public_send(attr)).to eq value
end

Then("every pixel of {tvar} is {color}") do |canvas, color|
  expect(instance_variable_get(canvas).pixels.all? { |p| p == color }).to eq(true)
end

When('write_pixel\({var}, {int}, {int}, {tvar})') do |canvas, row, col, color|
  instance_variable_get(canvas)[row, col] = instance_variable_get(color)
end

Then('pixel_at\({var}, {int}, {int}) = {tvar}') do |canvas, col, row, color|
  expect(instance_variable_get(canvas)[col, row]).to eq(instance_variable_get(color))
end

Then("{var} = {tvar}") do |var, var2|
  expect(instance_variable_get(var)).to eq(instance_variable_get(var2))
end

When('{var} ← canvas_to_ppm\({tvar})') do |var, canvas|
  instance_variable_set(var, instance_variable_get(canvas).to_ppm)
end

Then("lines {int}-{int} of {var} are") do |l0, l1, var, string|
  l0 -= 1
  l1 -= 1
  lines = instance_variable_get(var).split("\n")
  expect(lines[l0..l1].join("\n")).to eq(string)
end

When("every pixel of {var} is set to {color}") do |canvas, color|
  instance_variable_get(canvas).pixels=(color)
end

Then("{var} ends with a newline character") do |ppm|
  expect(instance_variable_get(ppm)[-1]).to eq("\n")
end
