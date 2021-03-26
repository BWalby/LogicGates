extends "res://addons/gut/test.gd"

func assert_array_size(result: Array, expected_size: int):
	assert_typeof(result, TYPE_ARRAY)
	assert_eq(result.size(), expected_size)

func test_ordered_graph_2_inputs_to_combinator():
	# A--\
	#	  ---Combinator
	# B--/
	
	var input_a = FixedInputComponent.new(true)
	var input_b = FixedInputComponent.new(true)
	var final_combinator = CombinatorComponent.new([input_a, input_b])
	
	var graph = GraphBuilder.get_ordered_graph(final_combinator)
	assert_array_size(graph, 3)
	
	var input_a_index = graph.find(input_a)
	var input_b_index = graph.find(input_b)
	#todo: why is this the wrong way round in the results and not as expected below, a=0, b=1
	assert_eq(input_a_index, 0)
	assert_eq(input_b_index, 1)
	
	var combinator_index = graph.find(final_combinator)
	assert_eq(combinator_index, 2)

func test_ordered_graph_2_ands_a_passed_to_second_then_combinator():
	# A---AND---\
	#     |      AND---\
	# B--/------/-------Combinator

	var input_a = FixedInputComponent.new(true, "a")
	var input_b = FixedInputComponent.new(true, "b")
	var first_and = ComponentHelper.create_and_component([input_a, input_b], "and1")
	var second_and = ComponentHelper.create_and_component([first_and, input_b], "and2")
	var final_combinator = CombinatorComponent.new([second_and, input_b], "combinator")

	var graph = GraphBuilder.get_ordered_graph(final_combinator)
	assert_array_size(graph, 5)

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
	var first_and = ComponentHelper.create_and_component([input_a, input_b])
	var second_and = ComponentHelper.create_and_component([first_and, input_a])
	var final_combinator = CombinatorComponent.new([second_and, input_b])

	var graph = GraphBuilder.get_ordered_graph(final_combinator)
	assert_array_size(graph, 5)

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
	var first_and = ComponentHelper.create_and_component([buffer_a, buffer_b])
	var final_combinator = CombinatorComponent.new([first_and, buffer_c])

	var graph = GraphBuilder.get_ordered_graph(final_combinator)
	assert_array_size(graph, 8)

	var input_a_index = graph.find(input_a)
	var input_b_index = graph.find(input_b)
	var input_c_index = graph.find(input_c)
	var buffer_a_index = graph.find(buffer_a)
	var buffer_b_index = graph.find(buffer_b)
	var buffer_c_index = graph.find(buffer_c)
	var first_and_index = graph.find(first_and)
	var combinator_index = graph.find(final_combinator)
	
	assert_eq(input_c_index, 0)
	assert_eq(buffer_c_index, 1)
	
	assert_eq(input_a_index, 2)
	assert_eq(buffer_a_index, 3)
	
	assert_eq(input_b_index, 4)
	assert_eq(buffer_b_index, 5)
	
	assert_eq(first_and_index, 6)
	assert_eq(combinator_index, 7)

func test_ordered_graph_xor_ic():
	var input_a = FixedInputComponent.new(true, "a")
	var input_b = FixedInputComponent.new(true, "b")
	var input_components = [input_a, input_b]
	
	var and_component = ComponentHelper.create_and_component(input_components, "and1")
	var not_component = ComponentHelper.create_not_component([and_component], "not")
	
	var or_component = ComponentHelper.create_or_component(input_components, "or")

	# NAND and OR, converge onto a single AND
	var final_and_component = ComponentHelper.create_and_component([not_component, or_component], "and2")
	
	var graph = GraphBuilder.get_ordered_graph(final_and_component)
	assert_array_size(graph, 6)

	var input_a_index = graph.find(input_a)
	var input_b_index = graph.find(input_b)
	var and_index = graph.find(and_component)
	var not_index = graph.find(not_component)
	var or_index = graph.find(or_component)
	var final_and_index = graph.find(final_and_component)
	
	assert_eq(input_a_index, 0)
	assert_eq(input_b_index, 1)
	assert_eq(and_index, 2)
	assert_eq(not_index, 3)
	assert_eq(or_index, 4)
	assert_eq(final_and_index, 5)
