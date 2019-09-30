Given('{mvar} ← translation\({int}, {int}, {int})') do |matrix, int, int2, int3|
  instance_variable_set(matrix, RT::Matrix.translation(int, int2, int3))
end

Given('{mvar} ← scaling\({int}, {int}, {int})') do |matrix, int, int2, int3|
  instance_variable_set(matrix, RT::Matrix.scaling(int, int2, int3))
end

Then('{tvar} ← {mvar} * {tvar}') do |point, matrix, point2|
  instance_variable_set(point, instance_variable_get(matrix) * instance_variable_get(point2))
end

Then('{tvar} = point\({int}, {int}, {int})') do |point, x, y, z|
  expect(instance_variable_get(point)).to be_within(EPSILON_TUPLE).of(RT::Point[x,y,z])
end

Then("{mvar} * {tvar} = {pvc}") do |matrix, point, new_point|
  p = instance_variable_get(point)
  expect(instance_variable_get(matrix) * p).to be_within(EPSILON_TUPLE).of(new_point)
end

Then("{mvar} * {tvar} = {tvar}") do |matrix, point, point2|
  v = instance_variable_get(point)
  v2 = instance_variable_get(point2)
  expect(instance_variable_get(matrix) * v).to eq(v2)
end

ParameterType(
  name: 'rotation',
  regexp: /rotation_[xyz]/,
  transformer: -> ( match ) { match.to_sym },
  use_for_snippets: false
)

Given('{mvar} ← {rotation}\(π / {number})') do |matrix, rotation, number|
  instance_variable_set(matrix, RT::Matrix.public_send(rotation, Math::PI / number))
end

Then('{mvar} * {tvar} = point\({number}\/{number}, {number}, {number}\/{number})') do |matrix, point, n, n2, n3, n4, n5|
  p = instance_variable_get(point)
  p1 = RT::Point[n/n2, n3, n4/n5]
  expect(instance_variable_get(matrix) * p).to be_within(EPSILON_TUPLE).of(p1)
end

Then('{mvar} * {tvar} = point\({number}\/{number}, {number}\/{number}, {number})') do |matrix, point, n, n2, n3, n4, n5|
  p = instance_variable_get(point)
  p1 = RT::Point[n/n2, n3/n4, n5]
  expect(instance_variable_get(matrix) * p).to be_within(EPSILON_TUPLE).of(p1)
end

Then('{mvar} * {tvar} = point\({number}, {number}\/{number}, {number}\/{number})') do |matrix,point, n, n2, n3, n4, n5|
  p = instance_variable_get(point)
  p1 = RT::Point[n, n2/n3, n4/n5]
  expect(instance_variable_get(matrix) * p).to be_within(EPSILON_TUPLE).of(p1)
end

Given('transform ← shearing\({int}, {int}, {int}, {int}, {int}, {int})') do |xy, xz, yx, yz, zx, zy|
  @matrix_transform = RT::Matrix.shearing(xy, xz, yx, yz, zx, zy)
end

When("{mvar} ← {mvar} * {mvar} * {mvar}") do |var, var2, var3, var4|
  c = instance_variable_get(var2)
  b = instance_variable_get(var3)
  a = instance_variable_get(var4)

  instance_variable_set(var, c * b * a)
end
