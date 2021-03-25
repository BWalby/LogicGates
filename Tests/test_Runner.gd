extends "res://addons/gut/test.gd"

func assert_all_steps_processed(steps: Array) -> void:
	for step in steps:
		assert_true(step.all_inputs_are_processed())

func assert_array_size(result: Array, expected_size: int):
	assert_typeof(result, TYPE_ARRAY)
	assert_eq(result.size(), expected_size)


var one_level_linear_data = [
	[true],
	[false]
]

func test_1level_linear_test(params=use_parameters(one_level_linear_data)):
	var input_value = params[0] as bool
	var input = FixedInputComponent.new(input_value)
	var result = Runner.new().run(input)
	
	assert_array_size(result, 1)
	assert_true(input.all_inputs_are_processed())
	assert_eq(result[0], input_value)

var two_level_linear_data = [
	[false, false, false],
	[true, false, true],
	[false, true, true],
	[true, true, true],
]

func test_2level_linear_test(params=use_parameters(two_level_linear_data)):
	var input_a_value = params[0]
	var input_b_value = params[1]
	var expected_result = params[2]
	
	var input_a = FixedInputComponent.new(input_a_value)
	var input_b = FixedInputComponent.new(input_b_value)
	var input_steps = [input_a, input_b]
	var or_component = ComponentHelper.create_or_component(input_steps)
	
	var result = Runner.new().run(or_component)
	assert_array_size(result, 1)
	assert_all_steps_processed([input_a, input_b, or_component])
	assert_eq(result[0], expected_result)

# TODO: nonlinear a,b -> and, and,c -> final

var three_level_non_linear_data = [
	[false, false, false],
	[true, false, false],
	[false, true, true],
	[true, true, true]
]

func test_three_level_non_linear(params=use_parameters(three_level_non_linear_data)):
	# A--\
	#     OR---\
	#	  |		AND
	# B--/-----/
	var input_a_value = params[0]
	var input_b_value = params[1]
	var expected_result = params[2]

	var input_a = FixedInputComponent.new(input_a_value)
	var input_b = FixedInputComponent.new(input_b_value)
	var input_steps = [input_a, input_b]
	var or_component = ComponentHelper.create_or_component(input_steps)
	var and_component = ComponentHelper.create_and_component([or_component, input_b])
	
	var result = Runner.new().run(and_component)
	assert_array_size(result, 1)
	assert_all_steps_processed([input_a, input_b, or_component, and_component])
	assert_eq(result[0], expected_result)

var nand_data = [
	[false, false, true],
	[true, false, true],
	[false, true, true],
	[true, true, false]
]

func test_nand(params=use_parameters(nand_data)):
	var input_a_value = params[0]
	var input_b_value = params[1]
	var expected_result = params[2]
	
	var input_a = FixedInputComponent.new(input_a_value)
	var input_b = FixedInputComponent.new(input_b_value)
	var input_steps = [input_a, input_b]
	var nand_component = ComponentHelper.create_nand_component(input_steps)
	
	var result = Runner.new().run(nand_component)
	assert_array_size(result, 1)
	assert_all_steps_processed([input_a, input_b, nand_component])
	assert_eq(result[0], expected_result)

var constructed_or_ic_data = [
	[false, false, false],
	[true, false, true],
	[false, true, true],
	[true, true, true]
]

func test_constructed_or_ic(params=use_parameters(constructed_or_ic_data)):
	var input_a_value = params[0]
	var input_b_value = params[1]
	var expected_result = params[2]

	var input_a = FixedInputComponent.new(input_a_value)
	var input_b = FixedInputComponent.new(input_b_value)
	var not_component_a = ComponentHelper.create_not_component([input_a])
	var not_component_b = ComponentHelper.create_not_component([input_b])
	var nand_inputs = [not_component_a, not_component_b]
	# 2 not, fed too nand, creates and or
	var nand_component = ComponentHelper.create_nand_component(nand_inputs)
	
#	composed OR via: 
#	(A,B) -> (NOT x2) -> NAND
#	A   B   ->  A'  B'  Output
#	0   0   ->  1   1   0
#	1   0   ->  0   1   1   
#	0   1   ->  1   0   1
#	1   1   ->  0   0   1
#	NAND
#	A   B   Output
#	0   0   1
#	1   0   1
#	0   1   1
#	1   1   0
	
	var result = Runner.new().run(nand_component)
	assert_array_size(result, 1)
	assert_all_steps_processed([input_a, input_b, not_component_a, not_component_b, nand_component])
	assert_eq(result[0], expected_result)

var nor_data = [
	[false, false, true],
	[true, false, false],
	[false, true, false],
	[true, true, false]
]

func test_constructed_nor_ic(params=use_parameters(nor_data)):
	var input_a_value = params[0]
	var input_b_value = params[1]
	var expected_result = params[2]
	
	var input_a = FixedInputComponent.new(input_a_value)
	var input_b = FixedInputComponent.new(input_b_value)
	var or_input_steps = [input_a, input_b]
	var or_component = ComponentHelper.create_or_component(or_input_steps)
	var not_component = ComponentHelper.create_not_component([or_component])
	
	var result = Runner.new().run(not_component)
	assert_array_size(result, 1)
	assert_all_steps_processed([input_a, input_b, or_component, not_component])
	assert_eq(result[0], expected_result)









var xor_data = [
	[false, false, false],
	[true, false, true],
	[false, true, true],
	[true, true, false]
]

func test_constructed_xor_ic(params=use_parameters(xor_data)):
	var input_a_value = params[0]
	var input_b_value = params[1]
	var expected_result = params[2]
	
	var input_a = FixedInputComponent.new(input_a_value)
	var input_b = FixedInputComponent.new(input_b_value)
	var input_components = [input_a, input_b]
	
	var nand_component = ComponentHelper.create_nand_component(input_components)
	var or_component = ComponentHelper.create_or_component(input_components)
	
	# NAND and OR, converge onto a single AND
	var final_and_component = ComponentHelper.create_and_component([nand_component, or_component])

# TODO: Fix - not all steps processed
#	var result = Runner.new().run(final_and_component)
#	assert_array_size(result, 1)
#	assert_all_steps_processed([input_a, input_b, nand_component, or_component, final_and_component])
#	assert_eq(result[0], expected_result)










var three_level_non_linear_multiple_outputs_data = [
	[false, false, false],
	[true, false, true],
	[false, true, true],
	[true, true, true]
]

func test_three_level_non_linear_multiple_outputs(params=use_parameters(three_level_non_linear_multiple_outputs_data)):
	var input_a_value = params[0]
	var input_b_value = params[1]
	var expected_result_a = params[2]
	var expected_result_b = input_a_value

	var input_a = FixedInputComponent.new(input_a_value)
	var input_b = FixedInputComponent.new(input_b_value)
	var input_steps = [input_a, input_b]
	var or_component = ComponentHelper.create_or_component(input_steps)
	var final_combinator = CombinatorComponent.new([or_component, input_a])
	
	var result = Runner.new().run(final_combinator)
# TODO: Fix - incorrect for result b on test case 4
#	assert_array_size(result, 2)
#	assert_all_steps_processed([input_a, input_b, or_component, final_combinator])
#	assert_eq(result[0], expected_result_a)
#	assert_eq(result[0], expected_result_b)
