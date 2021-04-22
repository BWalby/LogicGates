extends "res://addons/gut/test.gd"

var factory = ComponentFactory.new(GatePredicateHelper.new())

var theory_inline_data = [
	[false],
	[true]
]

func test_input_component(params=use_parameters(theory_inline_data)):
  var input_value = params[0]
  var component = factory.create_input_component(input_value, "Input")
  
  var result = component.process()
  assert_typeof(result, TYPE_ARRAY)
  assert_eq(result, params)

var post_update_data = [
  [true, true],
  [true, false],
  [false, true],
  [false, false]
]

func test_input_component_post_update_value(params=use_parameters(post_update_data)):
  var initial_value = params[0]
  var post_value = params[1]
  var component = factory.create_input_component(initial_value, "Input") as InputComponent
  component.process()
  component.update_input_value(post_value)
  
  var expected = [post_value]
  var result = component.process()
  assert_typeof(result, TYPE_ARRAY)
  assert_eq(result, expected)