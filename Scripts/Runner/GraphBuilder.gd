extends Object
class_name GraphBuilder

const pair_index_key := "index"
const pair_component_key := "component"

static func get_ordered_graph_internal(origin: Component, graph: Array, graph_input_steps: Array) -> void:
	# must be a root node (fixed input), no further processing on this branch required
	if !origin.input_steps:
		if !graph_input_steps.has(origin):
			graph_input_steps.append(origin)
		return
		
	if !graph.has(origin):
		graph.append(origin)
	
	# input steps ordered descending by most children (input_steps)
	# when two are equal, the index should then be used (highest first, as this gets inverted in final stages)
	var ordered_inputs = []
	for i in range(origin.input_steps.size()):
		ordered_inputs.append(create_index_component_pair(origin.input_steps[i], i))
		
	ordered_inputs.sort_custom(ComponentSorter, "sort_by_child_count_descending")
	
	for input in ordered_inputs:
		var component = input[pair_component_key]
		get_ordered_graph_internal(component, graph, graph_input_steps)

static func create_index_component_pair(component: Component, index: int) -> Dictionary:
	return {
		pair_index_key: index,
		pair_component_key: component
	}

static func get_ordered_graph(origin: Component) -> Array:
	var graph = []
	# these are the fixed inputs at the start of the graph
	var graph_input_steps = []
	get_ordered_graph_internal(origin, graph, graph_input_steps)
	
	# equivalent of array reverse
	graph.invert()
	
	# equivalent of insert range at 0
	for step in graph_input_steps:
		graph.push_front(step)
	
	#todo: make distinct before inserting
	return graph
