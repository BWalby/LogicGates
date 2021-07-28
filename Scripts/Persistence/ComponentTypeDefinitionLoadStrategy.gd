class_name ComponentTypeDefinitionLoadStrategy
extends Object

func load(dict: Dictionary) -> ComponentTypeDefinition:
	var type = dict[ComponentTypeDefinitionDataKeys.component_type_key]
	var type_uid = dict[ComponentTypeDefinitionDataKeys.uid_key]
	var name = dict[ComponentTypeDefinitionDataKeys.component_name_key]
	var predicate_type = dict[ComponentTypeDefinitionDataKeys.component_predicate_type_key]
	var input_count = dict[ComponentTypeDefinitionDataKeys.component_input_count_key]
	var output_count = dict[ComponentTypeDefinitionDataKeys.component_output_count_key]
	
	return ComponentTypeDefinition.new(type, predicate_type, input_count, output_count, name, type_uid)