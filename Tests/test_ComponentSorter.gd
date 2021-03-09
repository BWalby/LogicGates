extends "res://addons/gut/test.gd"

func create_component(input_count: int) -> Component:
	var inputs = []
	
	for i in input_count:
		inputs.append(FixedInputComponent.new(true))
	
	return Component.new(inputs, null)

func test_ComponentSorter_input_counts_distinct():
	var inputs_1 = create_component(1)
	var inputs_2 = create_component(2)
	var inputs_7 = create_component(7)
	var inputs_10 = create_component(10)
	
	# input = 2,7,10,1
	var array = [
		GraphBuilder.create_index_component_pair(inputs_2, 0),
		GraphBuilder.create_index_component_pair(inputs_7, 1),
		GraphBuilder.create_index_component_pair(inputs_10, 2),
		GraphBuilder.create_index_component_pair(inputs_1, 3)
	]
	array.sort_custom(ComponentSorter, "sort_by_child_count_descending")
	
	var input_counts_ordered = []
	for pair in array: 
		var component = pair[GraphBuilder.pair_component_key] as Component
		input_counts_ordered.append(component.input_steps.size())
	
	assert_eq(input_counts_ordered, [10, 7, 2, 1])
	
func test_ComponentSorter_equal_input_counts():
	var inputs_1 = create_component(1)
	var inputs_3_a = create_component(3)
	var inputs_3_b = create_component(3)
	var inputs_5 = create_component(5)
	
	var array = [
		GraphBuilder.create_index_component_pair(inputs_1, 0),
		GraphBuilder.create_index_component_pair(inputs_3_a, 1),
		GraphBuilder.create_index_component_pair(inputs_3_b, 2),
		GraphBuilder.create_index_component_pair(inputs_5, 3)
	]
	array.sort_custom(ComponentSorter, "sort_by_child_count_descending")
	
	var expected = [
		inputs_5, 
		inputs_3_b,
		inputs_3_a,
		inputs_1
	]
	
	for i in range(array.size()):
		# array is pairs (actually dictionary) of component, index
		var actual_component = array[i][GraphBuilder.pair_component_key]
		var expected_component = expected[i]
		assert_eq(actual_component, expected_component)
	
