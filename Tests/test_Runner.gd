extends "res://addons/gut/test.gd"

const gate_predicate_func: String = "predicate"

var one_level_linear_data = [
	[true],
	[false]
]

func test_1level_linear_test(params=use_parameters(one_level_linear_data)):
	var input_value = params[0] as bool
	var input = FixedInputComponent.new(input_value)
	var result = Runner.new().run(input)
	
	assert_typeof(result, TYPE_ARRAY)
	assert_true(input.all_inputs_are_processed())
	assert_eq(result.size(), 1)
	assert_eq(result[0], input_value)

var two_level_linear_data = [
	[false, false, false],
	[true, false, true],
	[false, true, true],
	[true, true, true],
]

func assert_all_steps_processed(steps: Array) -> void:
	for step in steps:
		assert_true(step.all_inputs_are_processed())
	

func test_2level_linear_test(params=use_parameters(two_level_linear_data)):
	var input_a_value = params[0]
	var input_b_value = params[1]
	var expected_result = params[2]
	
	var input_a = FixedInputComponent.new(input_a_value)
	var input_b = FixedInputComponent.new(input_b_value)
	var input_steps = [input_a, input_b]
	var or_component = ComponentHelper.create_or_component(input_steps)
	
	var result = Runner.new().run(or_component)
	assert_typeof(result, TYPE_ARRAY)
	assert_all_steps_processed([input_a, input_b, or_component])
	assert_eq(result.size(), 1)
	assert_eq(result[0], expected_result)

# TODO: nonlinear a,b -> and, and,c -> final

var three_level_non_linear_data = [
	[false, false, false],
	[true, false, false],
	[false, true, true],
	[true, true, true]
]

func three_level_non_linear_test(params=use_parameters(three_level_non_linear_data)):
	var input_a_value = params[0]
	var input_b_value = params[1]
	var expected_result = params[2]

	var input_a = FixedInputComponent.new(input_a_value)
	var input_b = FixedInputComponent.new(input_b_value)
	var input_steps = [input_a, input_b]
	var or_component = ComponentHelper.create_or_component(input_steps)
	var and_component = ComponentHelper.create_and_component([or_component, input_b])
	
	var result = Runner.new().run(and_component)
	assert_typeof(result, TYPE_ARRAY)
	assert_all_steps_processed([input_a, input_b, or_component, and_component])
	assert_eq(result.size(), 1)
	assert_eq(result[0], expected_result)

# TODO: WorkerNonLinear3LevelMultipleOutputTest
# TODO: WorkerNandOutputTest
# TODO: WorkerConstructedOrIcOutputTest
# TODO: WorkerNorOutputTest
# TODO: WorkerXorOutputTest
