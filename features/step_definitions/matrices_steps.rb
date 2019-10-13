require "ray_tracer/matrix"

ParameterType(
  name: 'mvar',
  regexp: /transform|inv|half_quarter|full_quarter|[A-Z]/,
  transformer: -> ( match ) { "@matrix_#{match}".to_sym },
  use_for_snippets: false
)

Given("the following {int}x{int} matrix {mvar}:") do |int, int2, matrix, table|
  data = table.raw.map{ |row| row.map { |i| Rational(i) } }
  instance_variable_set(matrix, RT::Matrix.build(int, int2) { |row, col| data[row][col] })
end

Given("the following matrix {mvar}:") do |matrix, table|
  data = table.raw.map{ |row| row.map { |i| Rational(i) } }
  instance_variable_set(matrix, RT::Matrix[*data])
end

Then("{mvar}[{int},{int}] = {number}") do |matrix, int, int2, number|
  m = instance_variable_get(matrix)
  expect(m[int, int2]).to eq(number)
end

Then("{mvar} = {mvar}") do |matrix, matrix2|
  expect(instance_variable_get(matrix) == instance_variable_get(matrix2)).to be
end

Then("{mvar} != {mvar}") do |matrix, matrix2|
  m = instance_variable_get(matrix)
  n = instance_variable_get(matrix2)
  expect(m != n).to be
end

Then("{mvar} * {mvar} is the following {int}x{int} matrix:") do |matrix, matrix2, int, int2, table|
  m = instance_variable_get(matrix)
  n = instance_variable_get(matrix2)
  data = table.raw.map { |row| row.map { |i| Rational(i) } }
  z = RT::Matrix.build(int, int2) { |row, col| data[row][col] }
  expect(m * n).to eq(z)
end

Then("{mvar} * {tvar} = {tuple}") do |matrix, tuple, tuple2|
  m = instance_variable_get(matrix)
  t = instance_variable_get(tuple)
  expect(m * t).to eq(tuple2)
end

Then("{mvar} * identity_matrix = {mvar}") do |matrix, matrix2|
  m = instance_variable_get(matrix)
  n = instance_variable_get(matrix2)
  i = RT::Matrix.identity(m.row_count)
  expect(m * i).to eq(n)
end

Then("identity_matrix * {tvar} = {tvar}") do |tuple, tuple2|
  t1 = instance_variable_get(tuple)
  t2 = instance_variable_get(tuple2)
  i = RT::Matrix.identity(t1.size)
  expect(i * t1).to eq(t2)
end

Then('transpose\({mvar}) is the following matrix:') do |matrix, table|
  m = instance_variable_get(matrix)
  data = table.raw.map{ |row| row.map { |i| Rational(i) } }
  z = RT::Matrix[*data]
  expect(m.transpose).to eq(z)
end

Given('{mvar} ← transpose\(identity_matrix)') do |matrix|
  instance_variable_set(matrix, RT::Matrix.identity(2).transpose)
end

Then("{mvar} = identity_matrix") do |matrix|
  a = instance_variable_get(matrix)
  i = RT::Matrix.identity(a.row_count)
  expect(a).to eq(i)
end

Then('determinant\({mvar}) = {number}') do |matrix, number|
  expect(instance_variable_get(matrix).determinant).to eq(number)
end

Then('submatrix\({mvar}, {int}, {int}) is the following {int}x{int} matrix:') do |matrix, int, int2, int3, int4, table|
  data = table.raw.map{ |row| row.map { |i| Rational(i) } }
  z = RT::Matrix.build(int3, int4) { |row, col| data[row][col] }

  m = instance_variable_get(matrix)
  expect(m.first_minor(int, int2)).to eq(z)
end

Given('{mvar} ← submatrix\({mvar}, {int}, {int})') do |matrix, matrix2, int, int2|
  m = instance_variable_get(matrix2)
  instance_variable_set(matrix, m.submatrix(int, int2))
end

Then('minor\({mvar}, {int}, {int}) = {number}') do |matrix, int, int2, number|
  m = instance_variable_get(matrix)
  expect(m.minor(int, int2)).to eq(number)
end

Then('cofactor\({mvar}, {int}, {int}) = {number}') do |matrix, int, int2, number|
  m = instance_variable_get(matrix)
  expect(m.cofactor(int, int2)).to eq(number)
end

Then("{mvar} is invertible") do |matrix|
  expect(instance_variable_get(matrix)).to be_invertible
end

Then("{mvar} is not invertible") do |matrix|
  expect(instance_variable_get(matrix)).not_to be_invertible
end

Given('{mvar} ← inverse\({mvar})') do |matrix, matrix2|
  m = instance_variable_get(matrix2)
  instance_variable_set(matrix, m.inverse)
end

Then('{mvar}[{int},{int}] = {number}\/{number}') do |matrix, int, int2, number, number2|
  m = instance_variable_get(matrix)
  expect(m[int,int2]).to be_within(EPSILON_FLOAT).of(number/number2)
end

Then("{mvar} is the following {int}x{int} matrix:") do |matrix, int, int2, table|
  m = instance_variable_get(matrix)
  data = table.raw.map { |row| row.map { |i| Rational(i) } }
  z = RT::Matrix.build(int, int2) { |row, col| data[row][col] }
  epsilon = RT::Matrix.build(int, int2) { 0.00001 }

  expect(m).to be_within(epsilon).of(z)
end

Then('inverse\({mvar}) is the following {int}x{int} matrix:') do |matrix, int, int2, table|
  m = instance_variable_get(matrix)
  data = table.raw.map { |row| row.map { |i| Rational(i) } }
  z = RT::Matrix.build(int, int2) { |row, col| data[row][col] }
  epsilon = RT::Matrix.build(int, int2) { 0.00001 }

  expect(m.inverse).to be_within(epsilon).of(z)
end

Given("{mvar} ← {mvar} * {mvar}") do |matrix, matrix2, matrix3|
  a = instance_variable_get(matrix2)
  b = instance_variable_get(matrix3)
  instance_variable_set(matrix, a * b)
end

Then('{mvar} * inverse\({mvar}) = {mvar}') do |matrix, matrix2, matrix3|
  c = instance_variable_get(matrix)
  b = instance_variable_get(matrix2)
  a = instance_variable_get(matrix3)
  epsilon = RT::Matrix.build(c.row_count) { 0.00001 }

  expect(c * b.inverse).to be_within(epsilon).of(a)
end
