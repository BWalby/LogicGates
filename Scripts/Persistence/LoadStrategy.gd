extends Object
class_name LoadStrategy

static func load(data: Dictionary, factory: ComponentFactory, custom_type_definitions: Dictionary) -> Component:
	var uid = data[DataKeys.uid_key]
	# TODO: use these somewhere
	var input_uids = data[DataKeys.input_uids_key]
	var identifier = data[DataKeys.id_key]
	var type_def_uid = data[DataKeys.type_definition_uid_key]
	var type_def = get_type_definition(type_def_uid, factory, custom_type_definitions)
	return factory.create_component(type_def, uid, identifier)

static func get_type_definition(type_def_uid: int, factory: ComponentFactory, custom_type_definitions: Dictionary) -> ComponentTypeDefinition:
	assert(type_def_uid != Enums.ComponentType.UNDEFINED, "Cannot get undefined ComponentTypeDefinition")

	match type_def_uid:
		Enums.ComponentType.AND:
			return factory.and_type_def
		Enums.ComponentType.NOT:
			return factory.not_type_def
		Enums.ComponentType.CUSTOM:
			assert(custom_type_definitions.has(type_def_uid), "Custom type definition does not exist: '%s'" % type_def_uid)
			return custom_type_definitions[type_def_uid]
		Enums.ComponentType.INPUT, Enums.ComponentType.PASS_THROUGH:
			assert(true, "TODO: NOT SURE HERE")
			return null
		_:
			assert(true, "Unsupported type definition UID")
			return null

static func populate_node_from_data(data: Dictionary, node: Node) -> void:
	if data.has_all([DataKeys.offset_x_key, DataKeys.offset_y_key]):
		node.offset = Vector2(data[DataKeys.offset_x_key], data[DataKeys.offset_y_key])
	
	if data.has_all([DataKeys.pos_x_key, DataKeys.pos_y_key]):
		node.position = Vector2(data[DataKeys.pos_x_key], data[DataKeys.pos_y_key])
	
	for key in data.keys():
		if DataKeys.auto_generate_data_keys.has(key):
			node.set(key, data[key])			
