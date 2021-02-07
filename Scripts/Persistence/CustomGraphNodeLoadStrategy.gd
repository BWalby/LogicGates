extends LoadStrategy

class_name CustomGraphNodeLoadStrategy

func load_meta_data(data: Dictionary, graph_node: Node) -> void:
	var metadata = data[DataKeys.metadata_key]
	
	#TODO: make this type safe, we don't concretely know what derived type of node this is or if it even has a setup(int, int) method!
	graph_node.setup(metadata["input_count"], metadata["output_count"])
