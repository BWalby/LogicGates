extends "res://addons/gut/test.gd"


const gate_predicate_func: String = "predicate"

var factory = ComponentFactory.new(GatePredicateHelper.new())

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
	var input_a = factory.create_input_component(params[0], "A")
	var input_b = factory.create_input_component(params[1], "B")
	var inputs_a_b = [input_a, input_b]
	var and_step = factory.create_and_component(inputs_a_b, "And")
	var combinator = factory.create_pass_through_component(inputs_a_b, "Combinator")
	
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
	var input_a = factory.create_input_component(params[0], "A")
	var input_b = factory.create_input_component(params[1], "B")
	var inputs_a_b = [input_a, input_b]

	var and_step = factory.create_and_component(inputs_a_b, "And")
	var not_step = factory.create_not_component([and_step], "Not")

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
