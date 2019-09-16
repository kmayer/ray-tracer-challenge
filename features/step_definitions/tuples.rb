require "tuple"

EPSILON = Tuple[0.00001, 0.00001, 0.00001, 0.00001]

ParameterType(
  name: 'varname',
  regexp: /[a-z][12]?|zero|norm/,
  transformer: -> ( match ) { "@#{match}".to_sym },
  use_for_snippets: false
)

ParameterType(
  name: 'number',
  regexp: /[-+]?[0-9]*\.?[0-9]+/,
  transformer: -> ( match ) { Float(match) }
)

ParameterType(
  name: 'operand',
  regexp: /[\+\-\*\/]/,
  transformer: -> ( match ) { match },
  use_for_snippets: false
)

ParameterType(
  name: 'tuple_attr',
  regexp: /[xyzw]/,
  transformer: -> (match) { match }
)

ParameterType(
  name: 'color_attr',
  regexp: /red|green|blue/,
  transformer: -> (match) { match }
)

ParameterType(
  name: 'tuple_method',
  regexp: /magnitude|normalize|dot|cross/,
  transformer: -> ( match ) { match },
  use_for_snippets: false
)

ParameterType(
  name: 'tuple',
  regexp: /Tuple\[([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+)\s*\]/,
  transformer: -> (x,y,z,w) { Tuple[x,y,z,w] }
)

ParameterType(
  name: 'point',
  regexp: /Point\[([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+)\s*\]/,
  transformer: -> (x,y,z) { Point[x,y,z] }
)

ParameterType(
  name: 'vector',
  regexp: /Vector\[([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+)\s*\]/,
  transformer: -> (x,y,z) { Vector[x,y,z] }
)

ParameterType(
  name: 'color',
  regexp: /Color\[([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+)\s*\]/,
  transformer: -> (x,y,z) { Color[x,y,z] }
)

ParameterType(
  name: 'pvc',
  regexp: /(Point|Vector|Color)\[([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+)\s*\]/,
  transformer: -> (klass,x,y,z) { Object.const_get(klass).new(x,y,z) }
)


Given("{varname} ← {tuple}") do |varname, tuple|
  instance_variable_set(varname, tuple)
end

Given("{varname} ← {pvc}") do |varname, point|
  instance_variable_set(varname, point)
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