require "ray_tracer/tuple"

TUPLES = { "point" => RT::Point, "vector" => RT::Vector, "color" => RT::Color}
EPSILON_TUPLE = RT::Tuple[0.00001, 0.00001, 0.00001, 0.00001]
EPSILON_FLOAT = 1e-15

ParameterType(
  name: 'var',
  regexp: /[a-z][a-z0-9]?|ppm/,
  transformer: ->(match) { "@#{match}".to_sym },
  use_for_snippets: false
)

ParameterType(
  name: 'tvar',
  regexp: /[a-z][1-4]?|zero|norm|red|origin|direction/,
  transformer: -> ( match ) { "@#{match}".to_sym },
  use_for_snippets: false
)

ParameterType(
  name: 'number',
  regexp: /([-+]?)([√]?)([0-9]*\.?[0-9]+)/,
  transformer: -> ( sign, sqrt, digits ) {
    number = Float(digits)
    number = (sqrt == "√" ? Math.sqrt(number) : number)
    number * ( sign == "-" ? -1 : 1)
  }
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
  regexp: /(point|vector|color)\(([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+),\s*([-+]?[0-9]*\.?[0-9]+)\s*\)/,
  transformer: -> (klass,x,y,z) {
    TUPLES[klass].send(:[], x, y, z)
  }
)

Given("{tvar} ← {pvc}") do |varname, point|
  instance_variable_set(varname, point)
end
