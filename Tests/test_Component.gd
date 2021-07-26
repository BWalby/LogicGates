extends "res://addons/gut/test.gd"

var factory := ComponentFactory.new(GatePredicateHelper.new())

var and_gate_config_inline_data = [
	[false, false, false],
	[true, false, false],
	[false, true, false],
	[true, true, true]
]

func test_component_and_gate_config(params=use_parameters(and_gate_config_inline_data)):
	var mock_data_a = [params[0]]
	var mock_data_b = [params[1]]
	var mock_a = MockHelper.mock_processed_pass_through(mock_data_a, "A")
	var mock_b = MockHelper.mock_processed_pass_through(mock_data_b, "B")
	
	var input_steps = [mock_a, mock_b]

	var and_component = factory.create_and_component("And")
	and_component.input_steps = input_steps

	var result = and_component.process()
	var expected = [params[2]]
	
	assert_typeof(result, TYPE_ARRAY)
	assert_eq(result, expected)
