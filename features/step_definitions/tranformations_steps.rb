Given('transform ← translation\({int}, {int}, {int})') do |int, int2, int3|
  @transform = RT::Matrix.translation(int, int2, int3)
end

Given('transform ← scaling\({int}, {int}, {int})') do |int, int2, int3|
  @transform = RT::Matrix.scaling(int, int2, int3)
end

Then("transform * {tvar} = {pvc}") do |point, new_point|
  p = instance_variable_get(point)
  expect(@transform * p).to eq(new_point)
end

Given('inv ← inverse\(transform)') do
  @inv = @transform.inverse
end

Then("inv * {tvar} = {pvc}") do |point, pvc|
  expect(@inv * instance_variable_get(point)).to eq(pvc)
end

Then("transform * v = v") do
  v = instance_variable_get(:@v)
  expect(@transform * v).to eq(v)
end

ParameterType(
  name: 'rotation',
  regexp: /rotation_[xyz]/,
  transformer: -> ( match ) { match.to_sym },
  use_for_snippets: false
)

Given('half_quarter ← {rotation}\(π / {number})') do |rotation, number|
  @half_quarter = RT::Matrix.public_send(rotation, Math::PI / number)
end

Given('full_quarter ← {rotation}\(π / {number})') do |rotation, number|
  @full_quarter = RT::Matrix.public_send(rotation, Math::PI / number)
end

Then('half_quarter * {tvar} = point\({number}, √{number}\/{number}, √{number}\/{number})') do |point, n, n2, n3, n4, n5|
  p = instance_variable_get(point)
  p1 = RT::Point[n, Math.sqrt(n2)/n3, Math.sqrt(n4)/n5]
  epsilon = RT::Matrix.build(p.size, p.size) { |i,j| 0.00001 }
  expect(@half_quarter * p).to be_within(EPSILON).of(p1)
end

Then('half_quarter * {tvar} = point\(√{number}\/{number}, {number}, √{number}\/{number})') do |point, n, n2, n3, n4, n5|
  p = instance_variable_get(point)
  p1 = RT::Point[Math.sqrt(n)/n2, n3, Math.sqrt(n4)/n5]
  epsilon = RT::Matrix.build(p.size, p.size) { |i,j| 0.00001 }
  expect(@half_quarter * p).to be_within(EPSILON).of(p1)
end

Then('half_quarter * {tvar} = point\(-√{number}\/{number}, √{number}\/{number}, {number})') do |point, n, n2, n3, n4, n5|
  p = instance_variable_get(point)
  p1 = RT::Point[-Math.sqrt(n)/n2, Math.sqrt(n3)/n4, n5]
  epsilon = RT::Matrix.build(p.size, p.size) { |i,j| 0.00001 }
  expect(@half_quarter * p).to be_within(EPSILON).of(p1)
end

Then('full_quarter * {tvar} = point\({number}, {number}, {number})') do |point, n, n2, n3|
  p = instance_variable_get(point)
  p1 = RT::Point[n, n2, n3]
  expect(@full_quarter * p).to be_within(EPSILON).of(p1)
end

Given('inv ← inverse\(half_quarter)') do
  @inv = @half_quarter.inverse
end

Then('inv * {tvar} = point\({number}, √{number}\/{number}, -√{number}\/{number})') do |point, n, n2, n3, n4, n5|
  p = instance_variable_get(point)
  p1 = RT::Point[n, Math.sqrt(n2)/n3, -Math.sqrt(n4)/n5]
  expect(@inv * p).to be_within(EPSILON).of(p1)
end