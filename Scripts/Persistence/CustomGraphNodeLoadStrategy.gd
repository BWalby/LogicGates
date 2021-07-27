extends LoadStrategy
class_name CustomGraphNodeLoadStrategy

func load_meta_data(data: Dictionary, graph_node: Node) -> void:
	var metadata = data[DataKeys.metadata_key]
	
	#TODO: make this type safe, we don't concretely know what derived type of node this is or if it even has a setup(int, int) method!
	graph_node.setup(metadata["input_count"], metadata["output_count"])

static func populate_node_from_data(data: Dictionary, node: Node) -> void:
	if data.has_all([DataKeys.offset_x_key, DataKeys.offset_y_key]):
		node.offset = Vector2(data[DataKeys.offset_x_key], data[DataKeys.offset_y_key])
	
	if data.has_all([DataKeys.pos_x_key, DataKeys.pos_y_key]):
		node.position = Vector2(data[DataKeys.pos_x_key], data[DataKeys.pos_y_key])
	
	for key in data.keys():
		if DataKeys.auto_generate_data_keys.has(key):
			node.set(key, data[key])