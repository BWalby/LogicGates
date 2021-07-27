extends Object
class_name LoadStrategy

static func load_type_def_uid(data: Dictionary) -> int:
	return data[DataKeys.type_definition_uid_key]

static func load(data: Dictionary, type_def: ComponentTypeDefinition) -> Component:
	var uid = data[DataKeys.uid_key]
	var identifier = data[DataKeys.id_key]
	
	assert(type_def != null, "type definition cannot be null, when loading the component")
	
	if type_def == null:
		return null
		
	var component = ComponentFactory.create_component(type_def, uid, identifier)
	component.input_uids = data[DataKeys.input_uids_key]

	return component
