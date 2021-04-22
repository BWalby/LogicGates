extends "res://addons/gut/test.gd"

var single_fixed_input_inline_data = [
	[true],
	[false]
]

# func test_combinator_component_single_input(params=use_parameters(single_fixed_input_inline_data)):
# 	var input_a = FixedInputComponent.new(params[0])
	
# 	var combinator = CombinatorComponent.new([input_a])
# 	input_a.process()
# 	var combinator_result = combinator.process()
	
# 	assert_typeof(combinator_result, TYPE_ARRAY)
# 	assert_eq(combinator_result, params)

# var three_fixed_input_inline_data = [
# 	[false, false, false],
# 	[true, false, false],
# 	[false, true, false],
# 	[false, false, true],
# 	[true, true, true]
# ]

# func test_combinator_component(params=use_parameters(three_fixed_input_inline_data)):
# 	var input_a = FixedInputComponent.new(params[0])
# 	var input_b = FixedInputComponent.new(params[1])
# 	var input_c = FixedInputComponent.new(params[2])
	
# 	var input_steps = [input_a, input_b, input_c]
# 	var combinator = CombinatorComponent.new(input_steps)
	
# 	for input in input_steps:
# 		input.process()
	
# 	var combinator_result = combinator.process()
	
# 	assert_typeof(combinator_result, TYPE_ARRAY)
# 	assert_eq(combinator_result, params)
