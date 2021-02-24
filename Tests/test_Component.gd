extends "res://addons/gut/test.gd"

var and_gate_config_inline_data = [
	[false, false, false],
	[true, false, false],
	[false, true, false],
	[true, true, true]
]

func create_mocked_processed_component(mocked_result: Array) -> Component:
	var component = Component.new([], null);
	component.result = mocked_result
	return component

func test_component_and_gate_config(params=use_parameters(and_gate_config_inline_data)):
	var mock_data_a = [params[0]]
	var mock_data_b = [params[1]]
	var mock_a = create_mocked_processed_component(mock_data_a)
	var mock_b = create_mocked_processed_component(mock_data_b)
	
	var input_steps = [mock_a, mock_b]
	var and_gate = AndGate.new()
	var and_component = Component.new(input_steps, funcref(and_gate, "predicate"))
	
	var result = and_component.process()
	var expected = [params[2]]
	
	assert_typeof(result, TYPE_ARRAY)
	assert_eq(result, expected)
