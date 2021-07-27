extends Object
class_name LoadStrategy

static func load(data: Dictionary, controller: ComponentController) -> Component:
	var uid = data[DataKeys.uid_key]
	# TODO: use these somewhere
	var input_uids = data[DataKeys.input_uids_key]
	var identifier = data[DataKeys.id_key]
	var type_def_uid = data[DataKeys.type_definition_uid_key]
	return controller.create_component(Enums.ComponentType.GATE, type_def_uid)

static func populate_node_from_data(data: Dictionary, node: Node) -> void:
	if data.has_all([DataKeys.offset_x_key, DataKeys.offset_y_key]):
		node.offset = Vector2(data[DataKeys.offset_x_key], data[DataKeys.offset_y_key])
	
	if data.has_all([DataKeys.pos_x_key, DataKeys.pos_y_key]):
		node.position = Vector2(data[DataKeys.pos_x_key], data[DataKeys.pos_y_key])
	
	for key in data.keys():
		if DataKeys.auto_generate_data_keys.has(key):
			node.set(key, data[key])			
