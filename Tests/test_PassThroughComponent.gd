extends "res://addons/gut/test.gd"

var factory = ComponentFactory.new(GatePredicateHelper.new())

var theory_inline_data = [
	[false, false],
	[true, true]
]

func test_pass_through_component(params=use_parameters(theory_inline_data)):
	var mocked_pass_through = MockHelper.mock_processed_pass_through([params[0]], "MockPassThrough")

	var inputs = [mocked_pass_through]
	var component = factory.create_pass_through_component(1, 100, "ConcretePassThrough")
	component.input_steps = inputs
	var result = component.process()

	var expected = [params[1]]
	assert_typeof(result, TYPE_ARRAY)
	assert_eq(result, expected)


var multiple_inputs_data = [
	[true, true, true],
	[false, true, true],
	[false, false, false]
]

func test_pass_through_component_with_multiple_inputs(params=use_parameters(multiple_inputs_data)):
	var mocked_pass_through_a = MockHelper.mock_processed_pass_through([params[0]], "MockPassThroughA")
	var mocked_pass_through_b = MockHelper.mock_processed_pass_through([params[1]], "MockPassThroughB")
	var mocked_pass_through_c = MockHelper.mock_processed_pass_through([params[2]], "MockPassThroughC")

	var inputs = [mocked_pass_through_a, mocked_pass_through_b, mocked_pass_through_c]
	var component = factory.create_pass_through_component(3, 100, "Concrete3InputPassThrough")
	component.input_steps = inputs
	var result = component.process()

	assert_typeof(result, TYPE_ARRAY)
	assert_eq(result, params)
	

var three_fixed_input_values = [
	[false, false, false],
	[true, false, false],
	[false, true, false],
	[false, false, true],
	[true, true, true]
]

func test_multiple_input_components_to_pass_through(input_values=use_parameters(three_fixed_input_values)):
	var input_a = factory.create_input_component(input_values[0], "InputA") as InputComponent
	var input_b = factory.create_input_component(input_values[1], "InputB") as InputComponent
	var input_c = factory.create_input_component(input_values[2], "InputC") as InputComponent
	
	var input_components = [input_a, input_b, input_c]
	for c in input_components:
		c.process()
	
	var pass_through = factory.create_pass_through_component(3, 100, "PassThrough")
	pass_through.input_steps = input_components
	var result = pass_through.process()

	assert_typeof(result, TYPE_ARRAY)
	assert_eq(result, input_values)
