extends Object
class_name LoadStrategy

static func load(data: Dictionary, factory: ComponentFactory, type_definitions: Array) -> Component:
	
	return factory.create_component()


func populate_node_from_data(data: Dictionary, node: Node) -> void:
	if data.has_all([DataKeys.offset_x_key, DataKeys.offset_y_key]):
		node.offset = Vector2(data[DataKeys.offset_x_key], data[DataKeys.offset_y_key])
	
	if data.has_all([DataKeys.pos_x_key, DataKeys.pos_y_key]):
		node.position = Vector2(data[DataKeys.pos_x_key], data[DataKeys.pos_y_key])
	
	for key in data.keys():
		if !manually_populate_properties.has(key):
			node.set(key, data[key])
