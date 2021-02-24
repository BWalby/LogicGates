extends Object
class_name GraphBuilder

static func get_ordered_graph_internal(origin: Component, graph: Array, input_steps: Array) -> void:
	if !origin.input_steps:
		input_steps.append(origin)
		return
	
	if !graph.has(origin):
		graph.append(origin)
	
	var origin_input_steps = origin.input_steps as Array
	
	#todo: implement custom descending sort (sort_custom()) on input_steps length
	#	var orderedInputs = origin.InputSteps.OrderByDescending(i => i.InputSteps?.Length ?? 0).ToArray();
	var ordered_inputs = origin_input_steps.sort()
	
	for step in ordered_inputs:
		get_ordered_graph_internal(step, graph, input_steps)


static func get_ordered_graph(origin: Component) -> Array:
	var input_steps = []
	var graph = []
	get_ordered_graph_internal(origin, graph, input_steps)
	
# todo: implement both functions for array
#	graph.reverse()
#	graph.insert_range(0, input_steps)
	
	return graph
