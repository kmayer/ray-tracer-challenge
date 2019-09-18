ParameterType(
  name: 'varname',
  regexp: /[a-z][1-3]?|zero|norm|red|ppm/,
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

Given("{varname} ← {pvc}") do |varname, point|
  instance_variable_set(varname, point)
end
