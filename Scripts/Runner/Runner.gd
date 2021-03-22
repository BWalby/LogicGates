extends Object
class_name Runner

var result: Array

func run(final_step: Component) -> Array:
	# todo: convert to GDScript
#      if (!(finalStep is OutputCombinatorStep) && !(finalStep is HierarchicalStep) && !(finalStep is FixedInputStep))
#        throw new ArgumentException($"Invalid {nameof(finalStep)} parameter");
	
	var ordered_graph = GraphBuilder.get_ordered_graph(final_step)

	for step in ordered_graph:
		step.process()
	
	result = final_step.result
	return result
