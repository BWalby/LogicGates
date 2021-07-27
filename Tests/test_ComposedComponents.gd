extends "res://addons/gut/test.gd"


const gate_predicate_func: String = "predicate"

var and_type_definition = TestSetupHelper.create_and_component_type_defintion()
var not_type_definition = TestSetupHelper.create_not_component_type_defintion()

var nonlinear_hierarchy_data = [
	[false, false, false],
	[true, false, false],
	[false, true, false],
	[true, true, true]
]
	
func test_nonlinear_hierarchy(params=use_parameters(nonlinear_hierarchy_data)):
	# A-----AND--\
	#    |		 Combinator
	# B----------/
	var input_a = ComponentFactory.create_input_component(params[0], "A")
	var input_b = ComponentFactory.create_input_component(params[1], "B")
	var inputs_a_b = [input_a, input_b]
	var and_step = ComponentFactory.create_component(and_type_definition, Uid.create())
	and_step.input_steps = inputs_a_b
	var combinator = ComponentFactory.create_pass_through_component(2, 100, "Combinator")
	combinator.input_steps = inputs_a_b
	
	input_a.process()
	input_b.process()
	
	var and_expected = [params[2]]
	var and_result = and_step.process()
	assert_typeof(and_result, TYPE_ARRAY)
	assert_eq(and_result, and_expected)

	var combinator_expected = [and_expected, input_b]
	var combinator_result = combinator.process()
	assert_typeof(combinator_result, TYPE_ARRAY)
	assert_eq(combinator_result, combinator_expected)

var nand_data = [
	[false, false, true],
	[true, false, true],
	[false, true, true],
	[true, true, false]
]

func test_nand_component(params=use_parameters(nand_data)):
	var input_a = ComponentFactory.create_input_component(params[0], "A")
	var input_b = ComponentFactory.create_input_component(params[1], "B")
	var inputs_a_b = [input_a, input_b]

	var and_step = ComponentFactory.create_component(and_type_definition, Uid.create(), "And")
	and_step.input_steps = inputs_a_b
	var not_step = ComponentFactory.create_component(not_type_definition, Uid.create(),"Not")
	not_step.input_steps = [and_step]

	input_a.process()
	input_b.process()
	
	var nand_expected = params[2]
	var and_expected = [!nand_expected]
	var and_result = and_step.process()
	assert_typeof(and_result, TYPE_ARRAY)
	assert_eq(and_result, and_expected)
	
	var not_result = not_step.process()
	assert_typeof(not_result, TYPE_ARRAY)
	assert_eq(not_result, [nand_expected])
