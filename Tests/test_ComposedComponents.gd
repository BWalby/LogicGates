extends "res://addons/gut/test.gd"

const gate_predicate_func: String = "predicate"

var nonlinear_hierarchy_data = [
	[false, false, false, false],
	[true, false, true, false],
	[false, true, true, true],
	[true, true, true, true]
]
	
func create_processed_fixed_input(input: bool) -> FixedInputComponent:
	var component = FixedInputComponent.new(input)
	component.process()
	return component

func test_nonlinear_hierarchy(params=use_parameters(nonlinear_hierarchy_data)):
	var input_a = create_processed_fixed_input(params[0])
	var input_b = create_processed_fixed_input(params[1])
	var or_step = ComponentHelper.create_or_component([input_a, input_b])
	var and_step = ComponentHelper.create_and_component([input_b, or_step])
	
	var or_expected = [params[2]]
	var or_result = or_step.process()
	assert_typeof(or_result, TYPE_ARRAY)
	assert_eq(or_result, or_expected)
	
	var and_expected = [params[3]]
	var and_result = and_step.process()
	assert_typeof(and_result, TYPE_ARRAY)
	assert_eq(and_result, and_expected)

var nand_data = [
	[false, false, true],
	[true, false, true],
	[false, true, true],
	[true, true, false]
]

func test_nand_component(params=use_parameters(nand_data)):
	var input_a = create_processed_fixed_input(params[0])
	var input_b = create_processed_fixed_input(params[1])
	var and_step = ComponentHelper.create_and_component([input_a, input_b])
	
	var not_gate = NotGate.new()
	var not_step = Component.new([and_step], funcref(not_gate, gate_predicate_func))
	
	var nand_expected = params[2]
	var and_expected = [!nand_expected]
	var and_result = and_step.process()
	assert_typeof(and_result, TYPE_ARRAY)
	assert_eq(and_result, and_expected)
	
	var not_result = not_step.process()
	assert_typeof(not_result, TYPE_ARRAY)
	assert_eq(not_result, [nand_expected])
