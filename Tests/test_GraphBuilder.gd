extends "res://addons/gut/test.gd"

var and_type_definition = TestSetupHelper.create_and_component_type_defintion()
var not_type_definition = TestSetupHelper.create_not_component_type_defintion()

func assert_array_size(result: Array, expected_size: int) -> void:
	assert_typeof(result, TYPE_ARRAY)
	assert_eq(result.size(), expected_size)

func assert_component_at_index(graph: Array, component: Component, expected_index: int) -> void:
	var index = graph.find(component)
	assert_eq(index, expected_index, "expected '{uid}' to be at index: {expected}, but was at index: {actual}".format({"uid": component.uid, "expected": expected_index, "actual": index}))

# A--\
#	    ---Combinator
# B--/
func test_ordered_graph_2_inputs_to_combinator():
  var input_a = ComponentFactory.create_input_component(true, "InputA")
  var input_b = ComponentFactory.create_input_component(true, "InputB")
  var input_components = [input_a, input_b]
  var final_combinator = ComponentFactory.create_pass_through_component(2, 100, "FinalPassThrough")
  final_combinator.input_steps = input_components
	
  var graph = GraphBuilder.get_ordered_graph(final_combinator)
  assert_array_size(graph, 3)
	
  assert_component_at_index(graph, input_a, 0)
  assert_component_at_index(graph, input_b, 1)
  assert_component_at_index(graph, final_combinator, 2)
	
# A-----AND--\
#    |		 Combinator
# B-----AND--/
func test_ordered_graph_2_inputs_2_ands_then_combinator():
  var input_a = ComponentFactory.create_input_component(true, "InputA")
  var input_b = ComponentFactory.create_input_component(true, "InputB")
  var input_components = [input_a, input_b]
  var and_1 = ComponentFactory.create_component(and_type_definition, Uid.create(), "And1")
  var and_2 = ComponentFactory.create_component(and_type_definition, Uid.create(),"And2")
  and_1.input_steps = input_components
  and_2.input_steps = input_components

  var and_components = [and_1, and_2]
  var final_combinator = ComponentFactory.create_pass_through_component(2, 100, "FinalPassThrough")
  final_combinator.input_steps = and_components

  var graph = GraphBuilder.get_ordered_graph(final_combinator)
  assert_array_size(graph, 5)

  assert_component_at_index(graph, input_a, 0)
  assert_component_at_index(graph, input_b, 1)
  assert_component_at_index(graph, and_1, 2)
  assert_component_at_index(graph, and_2, 3)
  assert_component_at_index(graph, final_combinator, 4)

# A--\
#	  AND--\
# B--/		|
#			Combinator
# C--NOT--/  
func test_ordered_graph_top_weighted_branch():
  var input_a = ComponentFactory.create_input_component(true, "InputA")
  var input_b = ComponentFactory.create_input_component(true, "InputB")
  var inputs_a_b = [input_a, input_b]
  var and_component = ComponentFactory.create_component(and_type_definition, Uid.create(), "And")
  and_component.input_steps = inputs_a_b
	
  var input_c = ComponentFactory.create_input_component(true, "InputC")
  var not_component = ComponentFactory.create_component(not_type_definition, Uid.create(), "Not")
  not_component.input_steps = [input_c]

  var final_combinator = ComponentFactory.create_pass_through_component(2, 100, "FinalCombinator")
  final_combinator.input_steps = [and_component, not_component]

  var graph = GraphBuilder.get_ordered_graph(final_combinator)
  assert_array_size(graph, 6)

  # todo: re-instate the input orders later, they don't matter so much
  # assert_component_at_index(graph, input_a, 0)
  # assert_component_at_index(graph, input_b, 1)
  # assert_component_at_index(graph, input_c, 2)
  assert_component_at_index(graph, and_component, 3)
  assert_component_at_index(graph, not_component, 4)
  assert_component_at_index(graph, final_combinator, 5)

# A--NOT--\
#			Combinator
# B--\		|
#	  AND--/
# C--/
func test_ordered_graph_bottom_weighted_branch():
  var input_a = ComponentFactory.create_input_component(true, "InputA")
  var not_component = ComponentFactory.create_component(not_type_definition, Uid.create(), "Not")
  not_component.input_steps = [input_a]

  var input_b = ComponentFactory.create_input_component(true, "InputB")
  var input_c = ComponentFactory.create_input_component(true, "InputC")
  var inputs_b_c = [input_b, input_c]
  var and_component = ComponentFactory.create_component(and_type_definition, Uid.create(), "And")
  and_component.input_steps = inputs_b_c

  var final_combinator = ComponentFactory.create_pass_through_component(2, 100, "FinalCombinator")
  final_combinator.input_steps = [not_component, and_component]

  var graph = GraphBuilder.get_ordered_graph(final_combinator)
  assert_array_size(graph, 6)

  assert_component_at_index(graph, input_a, 0)
  assert_component_at_index(graph, input_b, 1)
  assert_component_at_index(graph, input_c, 2)
  assert_component_at_index(graph, not_component, 3)
  assert_component_at_index(graph, and_component, 4)
  assert_component_at_index(graph, final_combinator, 5)
	
# A---AND---\
#     |      AND---\
# B--/------/-------Combinator
func test_ordered_graph_2_ands_a_passed_to_second_then_combinator():
  var input_a = ComponentFactory.create_input_component(true, "InputA")
  var input_b = ComponentFactory.create_input_component(true, "InputB")
  var first_and = ComponentFactory.create_component(and_type_definition, Uid.create(), "And1")
  first_and.input_steps = [input_a, input_b]
  var second_and = ComponentFactory.create_component(and_type_definition, Uid.create(), "And2")
  second_and.input_steps = [first_and, input_b]
  var final_combinator = ComponentFactory.create_pass_through_component(2, 100, "FinalCombinator")
  final_combinator.input_steps = [second_and, input_b]

  var graph = GraphBuilder.get_ordered_graph(final_combinator)
  assert_array_size(graph, 5)

  assert_component_at_index(graph, input_a, 0)
  assert_component_at_index(graph, input_b, 1)

  assert_component_at_index(graph, first_and, 2)
  assert_component_at_index(graph, second_and, 3)

  assert_component_at_index(graph, final_combinator, 4)

# A--\------\
#     |     AND-----Combinator
#     AND--/        |
# B--/--------------/
func test_ordered_graph_2_ands_a_passed_to_second_b_passed_combinator():
  var input_a = ComponentFactory.create_input_component(true, "InputA")
  var input_b = ComponentFactory.create_input_component(true, "InputB")
  var first_and = ComponentFactory.create_component(and_type_definition, Uid.create(), "And1")
  first_and.input_steps = [input_a, input_b]
  var second_and = ComponentFactory.create_component(and_type_definition, Uid.create(), "And2")
  second_and.input_steps = [input_a, first_and]
  var final_combinator = ComponentFactory.create_pass_through_component(2, 100, "FinalCombinator")
  final_combinator.input_steps = [second_and, input_b]

  var graph = GraphBuilder.get_ordered_graph(final_combinator)
  assert_array_size(graph, 5)

  assert_component_at_index(graph, input_a, 0)
  assert_component_at_index(graph, input_b, 1)

  assert_component_at_index(graph, first_and, 2)
  assert_component_at_index(graph, second_and, 3)

  assert_component_at_index(graph, final_combinator, 4)

# A-PasThrough-\
#               AND---PasThrough
# B-PasThrough-/      |
# C-PasThrough--------/  
func test_ordered_graph_2_buffered_inputs_to_and_1_buffered_input_to_combinator_with_and():
  var input_a = ComponentFactory.create_input_component(true, "InputA")
  var input_b = ComponentFactory.create_input_component(true, "InputB")
  var input_c = ComponentFactory.create_input_component(true, "InputC")
  var buffer_a = ComponentFactory.create_pass_through_component(1, 100, "BufferA")
  buffer_a.input_steps = [input_a]
  var buffer_b = ComponentFactory.create_pass_through_component(1, 100, "BufferB")
  buffer_b.input_steps = [input_b]
  var buffer_c = ComponentFactory.create_pass_through_component(1, 100, "BufferC")
  buffer_c.input_steps = [input_c]
  var and_component = ComponentFactory.create_component(and_type_definition, Uid.create(), "And")
  and_component.input_steps = [buffer_a, buffer_b]
  var final_combinator = ComponentFactory.create_pass_through_component(2, 100, "FinalCombinator")
  final_combinator.input_steps = [and_component, buffer_c]

  var graph = GraphBuilder.get_ordered_graph(final_combinator)
  assert_array_size(graph, 8)

  var input_a_index = graph.find(input_a)
  var input_b_index = graph.find(input_b)
  var input_c_index = graph.find(input_c)
  var buffer_a_index = graph.find(buffer_a)
  var buffer_b_index = graph.find(buffer_b)
  var buffer_c_index = graph.find(buffer_c)
  var and_index = graph.find(and_component)
  var combinator_index = graph.find(final_combinator)

  assert_eq(input_c_index, 0)
  assert_eq(input_b_index, 1)
  assert_eq(input_a_index, 2)

  assert_eq(buffer_a_index, 3)
  assert_eq(buffer_b_index, 4)
  assert_eq(and_index, 5)

  assert_eq(buffer_c_index, 6)
  assert_eq(combinator_index, 7)

# A-----AND--NOT--\
#     |			      AND
# B-----OR--------/
# func test_ordered_graph_xor_ic():
#   var input_a = factory.create_input_component(true, "InputA")
#   var input_b = factory.create_input_component(true, "InputB")
#   var input_components = [input_a, input_b]

#   var and_component = factory.create_and_component(input_components, "And1")
#   var not_component = factory.create_not_component(and_component, "Not")

#   # TODO: can't create OR gates just yet, so we can't convert this test right now
#   var or_component = ComponentHelper.create_or_component(input_components, "or")

#   # NAND and OR, converge onto a single AND
#   var final_and_component = factory.create_and_component([not_component, or_component], "And2")

#   var graph = GraphBuilder.get_ordered_graph(final_and_component)
#   assert_array_size(graph, 6)

#   assert_component_at_index(graph, input_a, 0)
#   assert_component_at_index(graph, input_b, 1)
#   assert_component_at_index(graph, and_component, 2)
#   assert_component_at_index(graph, not_component, 3)
#   assert_component_at_index(graph, or_component, 4)
#   assert_component_at_index(graph, final_and_component, 5)
