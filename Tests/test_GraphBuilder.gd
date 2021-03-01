extends "res://addons/gut/test.gd"

const gate_predicate_func: String = "predicate"

func create_and_component(inputs: Array) -> Component:
	var and_gate = AndGate.new()
	return Component.new(inputs, funcref(and_gate, gate_predicate_func))

func test_ordered_graph_2_ands_a_passed_to_second_then_combinator():
	# A---AND---\
	#     |      AND---\
	# B--/------/-------Combinator
	
	var input_a = FixedInputComponent.new(true)
	var input_b = FixedInputComponent.new(true)
	var first_and = create_and_component([input_a, input_b])
	var second_and = create_and_component([first_and, input_b])
	var final_combinator = CombinatorComponent.new([second_and, input_b])
	
	var graph = GraphBuilder.get_ordered_graph(final_combinator)
	assert_typeof(graph, TYPE_ARRAY)
	assert_eq(graph.count(), 5)
	
	var input_a_index = graph.find(input_a)
	var input_b_index = graph.find(input_b)
	assert_eq(input_a_index, 0)
	assert_eq(input_b_index, 1)
	
	var first_and_index = graph.find(first_and)
	var second_and_index = graph.find(second_and)
	assert_eq(first_and_index, 2)
	assert_eq(second_and_index, 3)
	
	var combinator_index = graph.find(final_combinator)
	assert_eq(combinator_index, 4)

func test_ordered_graph_2_ands_a_passed_to_second_b_passed_combinator():
	# A--\------\
	#     |     AND-----Combinator
	#     AND--/        |
	# B--/--------------/
	
	var input_a = FixedInputComponent.new(true)
	var input_b = FixedInputComponent.new(true)
	var first_and = create_and_component([input_a, input_b])
	var second_and = create_and_component([first_and, input_a])
	var final_combinator = CombinatorComponent.new([second_and, input_b])
	
	var graph = GraphBuilder.get_ordered_graph(final_combinator)
	assert_typeof(graph, TYPE_ARRAY)
	assert_eq(graph.count(), 5)
	
	var input_a_index = graph.find(input_a)
	var input_b_index = graph.find(input_b)
	assert_eq(input_a_index, 0)
	assert_eq(input_b_index, 1)
	
	var first_and_index = graph.find(first_and)
	var second_and_index = graph.find(second_and)
	assert_eq(first_and_index, 2)
	assert_eq(second_and_index, 3)
	
	var combinator_index = graph.find(final_combinator)
	assert_eq(combinator_index, 4)

func test_ordered_graph_2_buffered_inputs_to_and_1_buffered_input_to_combinator_with_and():
	# A-Combinator-\
	#               AND---Combinator
	# B-Combinator-/      |
	# C-Combinator--------/
	
	var input_a = FixedInputComponent.new(true)
	var input_b = FixedInputComponent.new(true)
	var input_c = FixedInputComponent.new(true)
	var buffer_a = CombinatorComponent.new([input_a])
	var buffer_b = CombinatorComponent.new([input_b])
	var buffer_c = CombinatorComponent.new([input_c])
	var first_and = create_and_component([buffer_a, buffer_b])
	var final_combinator = CombinatorComponent.new([first_and, buffer_c])
	
	var graph = GraphBuilder.get_ordered_graph(final_combinator)
	assert_typeof(graph, TYPE_ARRAY)
	assert_eq(graph.count(), 8)
	
	var input_a_index = graph.find(input_a)
	var input_b_index = graph.find(input_b)
	var input_c_index = graph.find(input_c)
	assert_eq(input_a_index, 0)
	assert_eq(input_b_index, 1)
	assert_eq(input_c_index, 2)
	
	#
	#	TODO: check these indices are correct??????
	#
	
	var buffer_c_index = graph.find(buffer_c)
	assert_eq(buffer_c_index, 3)
	
	var buffer_a_index = graph.find(buffer_a)
	var buffer_b_index = graph.find(buffer_b)
	var first_and_index = graph.find(first_and)
	assert_eq(buffer_a_index, 5)
	assert_eq(buffer_b_index, 4)
	assert_eq(first_and_index, 6)
	
	var combinator_index = graph.find(final_combinator)
	assert_eq(combinator_index, 7)
