require "ray_tracer/tuple"

EPSILON = RT::Tuple[0.00001, 0.00001, 0.00001, 0.00001]

Given("{varname} ← {tuple}") do |varname, tuple|
  instance_variable_set(varname, tuple)
end

Then("{varname}.{tuple_attr} = {float}") do |varname, attr, float|
  expect(instance_variable_get(varname).public_send(attr)).to eq float
end

Then("{varname}.{color_attr} = {float}") do |varname, attr, float|
  expect(instance_variable_get(varname).public_send(attr)).to eq float
end

Then("{varname} is a point") do |varname|
  expect(instance_variable_get(varname).point?).to be
end

Then("{varname} is not a point") do |varname|
  expect(instance_variable_get(varname).point?).not_to be
end

Then("{varname} is a vector") do |varname|
  expect(@a.vector?).to be
end

Then("{varname} is not a vector") do |varname|
  expect(@a.vector?).not_to be
end

Then("{varname} = {tuple}") do |varname, tuple|
  expect(instance_variable_get(varname)).to eq(tuple)
end

Then("-{varname} = {tuple}") do |varname, tuple|
  expect(-instance_variable_get(varname)).to eq(tuple)
end

Then("{varname} {operand} {varname} = {tuple}") do |var1, operand, var2, tuple|
  expect(instance_variable_get(var1).public_send(operand, instance_variable_get(var2))).to eq(tuple)
end

Then("{varname} {operand} {varname} = {pvc}") do |var1, operand, var2, pvc|
  expect(instance_variable_get(var1).public_send(operand, instance_variable_get(var2))).to be_within(EPSILON).of(pvc)
end

Then("{varname} {operand} {number} = {tuple}") do |var1, operand, number, tuple|
  expect(instance_variable_get(var1).public_send(operand, number)).to eq(tuple)
end

Then("{varname} {operand} {number} = {pvc}") do |var1, operand, number, pvc|
  expect(instance_variable_get(var1).public_send(operand, number)).to eq(pvc)
end

Then("{varname}.{tuple_method} = {number}") do |var, method, value|
  expect(instance_variable_get(var).public_send(method)).to eq(value)
end

Then("{varname}.{tuple_method} = √{number}") do |var, method, value|
  expect(instance_variable_get(var).public_send(method)).to eq(Math.sqrt(value))
end

Then("{varname}.{tuple_method} = (approximately ){vector}") do |var, method, vector|
  expect(instance_variable_get(var).public_send(method)).to be_within(EPSILON).of(vector)
end

Then("{varname} {tuple_method} {varname} = {number}") do |var1, method, var2, float|
  expect(instance_variable_get(var1).public_send(method, instance_variable_get(var2))).to eq(float)
end

Then("{varname} {tuple_method} {varname} = {pvc}") do |var1, method, var2, vector|
  expect(instance_variable_get(var1).public_send(method, instance_variable_get(var2))).to eq(vector)
end

When("{varname} ← {varname}.{tuple_method}") do |var1, var2, method|
  instance_variable_set(var1, instance_variable_get(var2).public_send(method))
end