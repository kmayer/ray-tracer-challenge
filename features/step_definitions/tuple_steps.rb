require "ray_tracer/tuple"

EPSILON = RT::Tuple[0.00001, 0.00001, 0.00001, 0.00001]

Given("{tvar} ← {tuple}") do |varname, tuple|
  instance_variable_set(varname, tuple)
end

Then("{tvar}.{tuple_attr} = {float}") do |varname, attr, float|
  expect(instance_variable_get(varname).public_send(attr)).to eq float
end

Then("{tvar}.{color_attr} = {float}") do |varname, attr, float|
  expect(instance_variable_get(varname).public_send(attr)).to eq float
end

Then("{tvar} is a point") do |varname|
  expect(instance_variable_get(varname).point?).to be
end

Then("{tvar} is not a point") do |varname|
  expect(instance_variable_get(varname).point?).not_to be
end

Then("{tvar} is a vector") do |varname|
  expect(@a.vector?).to be
end

Then("{tvar} is not a vector") do |varname|
  expect(@a.vector?).not_to be
end

Then("{tvar} = {tuple}") do |varname, tuple|
  expect(instance_variable_get(varname)).to eq(tuple)
end

Then("-{tvar} = {tuple}") do |varname, tuple|
  expect(-instance_variable_get(varname)).to eq(tuple)
end

Then("{tvar} {operand} {tvar} = {tuple}") do |var1, operand, var2, tuple|
  expect(instance_variable_get(var1).public_send(operand, instance_variable_get(var2))).to eq(tuple)
end

Then("{tvar} {operand} {tvar} = {pvc}") do |var1, operand, var2, pvc|
  expect(instance_variable_get(var1).public_send(operand, instance_variable_get(var2))).to be_within(EPSILON).of(pvc)
end

Then("{tvar} {operand} {number} = {tuple}") do |var1, operand, number, tuple|
  expect(instance_variable_get(var1).public_send(operand, number)).to eq(tuple)
end

Then("{tvar} {operand} {number} = {pvc}") do |var1, operand, number, pvc|
  expect(instance_variable_get(var1).public_send(operand, number)).to eq(pvc)
end

Then('{tuple_method}\({tvar}) = {number}') do |method, var, value|
  expect(instance_variable_get(var).public_send(method)).to eq(value)
end

Then('{tuple_method}\({tvar}) = √{number}') do |method, var, value|
  expect(instance_variable_get(var).public_send(method)).to eq(Math.sqrt(value))
end

Then('{tuple_method}\({tvar}) = (approximately ){vector}') do |method, var, vector|
  expect(instance_variable_get(var).public_send(method)).to be_within(EPSILON).of(vector)
end

Then('{tuple_method}\({tvar}, {tvar}) = {number}') do |method, var1, var2, float|
  expect(instance_variable_get(var1).public_send(method, instance_variable_get(var2))).to eq(float)
end

Then('{tuple_method}\({tvar}, {tvar}) = {pvc}') do |method, var1, var2, vector|
  expect(instance_variable_get(var1).public_send(method, instance_variable_get(var2))).to be_within(EPSILON).of(vector)
end

When('{tvar} ← {tuple_method}\({tvar})') do |var1, method, var2|
  instance_variable_set(var1, instance_variable_get(var2).public_send(method))
end