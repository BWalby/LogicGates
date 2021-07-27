extends Object
class_name LoadStrategy

static func load_type_def_uid(data: Dictionary) -> int:
	return data[DataKeys.type_definition_uid_key]

static func load(data: Dictionary, type_def: ComponentTypeDefinition, factory: ComponentFactory) -> Component:
	var uid = data[DataKeys.uid_key]
	var identifier = data[DataKeys.id_key]
	
	assert(type_def != null, "type definition cannot be null, when loading the component")
	
	if type_def == null:
		return null
		
	var component = factory.create_component(type_def, uid, identifier)
	
	# TODO: use these somewhere
	# var input_uids = data[DataKeys.input_uids_key]

	return component

static func populate_node_from_data(data: Dictionary, node: Node) -> void:
	if data.has_all([DataKeys.offset_x_key, DataKeys.offset_y_key]):
		node.offset = Vector2(data[DataKeys.offset_x_key], data[DataKeys.offset_y_key])
	
	if data.has_all([DataKeys.pos_x_key, DataKeys.pos_y_key]):
		node.position = Vector2(data[DataKeys.pos_x_key], data[DataKeys.pos_y_key])
	
	for key in data.keys():
		if DataKeys.auto_generate_data_keys.has(key):
			node.set(key, data[key])
