require "ray_tracer/tuple"

TUPLES = { "point" => RT::Point, "vector" => RT::Vector, "color" => RT::Color}
EPSILON_RATIONAL = 1e-5 # 1/100_000
EPSILON_FLOAT = 1e-15
EPSILON_TUPLE = RT::Tuple[EPSILON_RATIONAL, EPSILON_RATIONAL, EPSILON_RATIONAL, EPSILON_RATIONAL]

ParameterType(
  name: 'var',
  regexp: /[a-z][a-z0-9]?|ppm/,
  transformer: ->(match) { "@#{match}".to_sym },
  use_for_snippets: false
)

ParameterType(
  name: 'tvar',
  regexp: /[a-z][1-4]?|zero|norm|red|origin|direction|intensity|position|light|eyev|normalv|light/,
  transformer: -> ( match ) { "@#{match}".to_sym },
  use_for_snippets: false
)

NUMBER_REGEX=/([-+]?)([√]?)([0-9]*\.?[0-9]+)/

NUMBER_TRANSFORMER = -> (sign, sqrt, digits) {
  number  = Rational(digits)
  number = (sqrt == "√" ? Math.sqrt(number) : number)
  number * (sign == "-" ? -1 : 1)
}

RATIONAL_TRANSFORMER = -> (sign, sqrt, digits, divisor) {
  number = NUMBER_TRANSFORMER.(sign, sqrt, digits)
  divisor = Rational(divisor)
  Rational(number / divisor)
}

ParameterType(
  name:        'number',
  regexp:      NUMBER_REGEX,
  transformer: NUMBER_TRANSFORMER
)

ParameterType(
  name:        'rational',
  regexp:      /#{NUMBER_REGEX}\/([0-9]*\.?[0-9]+)/,
  transformer: RATIONAL_TRANSFORMER
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
  transformer: -> (match) { match },
  use_for_snippets: false
)

ParameterType(
  name: 'color_attr',
  regexp: /red|green|blue/,
  transformer: -> (match) { match }
)

ParameterType(
  name: 'tuple_method',
  regexp: /magnitude|normalize|dot|cross|blend/,
  transformer: -> ( match ) { match },
  use_for_snippets: false
)

ParameterType(
  name: 'tuple',
  regexp: /tuple\(([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+)\s*\)/,
  transformer: -> (x,y,z,w) { RT::Tuple[x,y,z,w] }
)

ParameterType(
  name: 'point',
  regexp: /Point\[([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+)\s*\]/,
  transformer: -> (x,y,z) { RT::Point[x,y,z] }
)

ParameterType(
  name: 'vector',
  regexp: /vector\(([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+)\s*\)/,
  transformer: -> (x,y,z) { RT::Vector[x,y,z] }
)

ParameterType(
  name: 'color',
  regexp: /color\(([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+)\s*\)/,
  transformer: -> (x,y,z) { RT::Color[x,y,z] }
)

ParameterType(
  name: 'pvc',
  regexp: /(point|vector|color)\(#{NUMBER_REGEX},\s*#{NUMBER_REGEX},\s*#{NUMBER_REGEX}\s*\)/,
  transformer: -> (klass, x_sign, x_rad, x_digits, y_sign, y_rad, y_digits, z_sign, z_rad, z_digits) {
    TUPLES[klass].send(:[], NUMBER_TRANSFORMER.(x_sign, x_rad, x_digits), NUMBER_TRANSFORMER.(y_sign, y_rad, y_digits), NUMBER_TRANSFORMER.(z_sign, z_rad, z_digits))
  }
)

ParameterType(
  name: 'transform',
  regexp: /translation|scaling/,
  transformer: ->(match) { match }
)

ParameterType(
  name: 'rotation',
  regexp: /rotation_[xyz]/,
  transformer: -> ( match ) { match.to_sym },
  use_for_snippets: false
)

Given("{tvar} ← {pvc}") do |varname, point|
  instance_variable_set(varname, point)
end

Given('{var} ← {transform}\({number}, {number}, {number})') do |matrix, transform, x, y, z|
  instance_variable_set(matrix, RT::Matrix.public_send(transform, x, y, z))
end

Then('{var} = {pvc}') do |normal_vector, vector|
  expect(instance_variable_get(normal_vector)).to be_within(EPSILON_TUPLE).of(vector)
end

Then('{tvar} ← vector\({number}, {rational}, {rational})') do |var, x, y, z|
  instance_variable_set(var, RT::Vector[x, y, z])
end

Then('{tvar} ← vector\({rational}, {rational}, {rational})') do |var, x, y, z|
  instance_variable_set(var, RT::Vector[x, y, z])
end

