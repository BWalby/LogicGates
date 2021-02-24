extends "res://addons/gut/test.gd"

var theory_inline_data = [
	[false, false],
	[true, true]
]

func test_fixed_input_component(params=use_parameters(theory_inline_data)):
	var result = FixedInputComponent.new(params[0]).process()
	var expected = [params[1]]
	
	assert_typeof(result, TYPE_ARRAY)
	assert_eq(result, expected)
