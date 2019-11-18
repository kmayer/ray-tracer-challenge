require "ray_tracer/light"

ParameterType(
  name: 'light_attr',
  regexp: /position|intensity/,
  transformer: -> (match) { match },
  use_for_snippets: false
)

When('{tvar} ← point_light\({tvar}, {tvar})') do |light, position, intensity|
  instance_variable_set(light,RT::Light.new(instance_variable_get(position), instance_variable_get(intensity)))
end

When('{tvar} ← point_light\({pvc}, {color})') do |light, position, intensity|
  instance_variable_set(light,RT::Light.new(position, intensity))
end

Then('{tvar}.{light_attr} = {tvar}') do |light, attr, tuple|
  expect(instance_variable_get(light).public_send(attr)).to eq(instance_variable_get(tuple))
end
