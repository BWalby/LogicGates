extends Object
class_name ComponentTypeDefinitionSaveStrategy

const data_keys = [
	ComponentTypeDefinitionDataKeys.component_name_key,
	ComponentTypeDefinitionDataKeys.uid_key,
	ComponentTypeDefinitionDataKeys.component_type_key,
	ComponentTypeDefinitionDataKeys.component_predicate_type_key,
	ComponentTypeDefinitionDataKeys.component_input_count_key,
	ComponentTypeDefinitionDataKeys.component_output_count_key
]

static func generate_data_dict(definition: ComponentTypeDefinition) -> Dictionary:
	var dict = { }
	
	for key in data_keys:
		dict[key] = definition[key]
	
	return dict
