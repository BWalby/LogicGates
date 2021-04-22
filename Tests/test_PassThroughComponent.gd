extends "res://addons/gut/test.gd"

var factory = ComponentFactory.new(GatePredicateHelper.new())

var theory_inline_data = [
	[false, false],
	[true, true]
]

func test_pass_through_component(params=use_parameters(theory_inline_data)):
	var mocked_pass_through = MockHelper.mock_processed_pass_through([params[0]], "MockPassThrough")

	var inputs = [mocked_pass_through]
	var component = factory.create_pass_through_component(inputs, "ConcretePassThrough")
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
	var component = factory.create_pass_through_component(inputs, "Concrete3InputPassThrough")
	var result = component.process()

	assert_typeof(result, TYPE_ARRAY)
	assert_eq(result, params)
	
