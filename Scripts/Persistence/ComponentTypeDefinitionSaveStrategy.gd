extends Object
class_name ComponentTypeDefinitionSaveStrategy

static func generate_data_dict(definition: ComponentTypeDefinition) -> Dictionary:
	var dict = { }
	
	for key in ComponentTypeDefinitionDataKeys.data_keys:
		dict[key] = definition[key]
	
	return dict
