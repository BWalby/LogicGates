extends Object
class_name ComponentController

var predicate_helper: GatePredicateHelper = GatePredicateHelper.new()

var custom_type_definitions: Array = []
var components: Array = []

signal custom_definition_added(type_definition)
signal custom_definition_removed(type_definition)
signal component_added(component)
signal component_removed(component)

func add_definition(definition: ComponentTypeDefinition) -> void:
	custom_type_definitions.append(definition)
	emit_signal("custom_definition_added", definition)
	
func remove_definition(definition: ComponentTypeDefinition) -> void:
	custom_type_definitions.erase(definition)
	emit_signal("custom_definition_removed", definition)
	
func add_component(component: Component) -> void:
	components.append(component)
	emit_signal("component_added", component)
	
func remove_component(component: Component) -> void:
	components.erase(component)
	emit_signal("component_removed", component)

func load_definitions(dictionaries: Array) -> void:
	for dictionary in dictionaries:
		var definition = load_definition(dictionary)
		add_definition(definition)


func load_components(dictionaries: Array) -> void:
	for dictionary in dictionaries:
		var component = load_component(dictionary)
		add_component(component)

func validate_definition_dictionary(dict: Dictionary) -> void:
	var keys_to_validate = ComponentTypeDefinitionDataKeys.data_keys
	
	for key in keys_to_validate:
		assert(dict.has(key), "ComponentTypeDefinition key missing {_}".format(key))

func load_definition(dict: Dictionary) -> ComponentTypeDefinition:
	validate_definition_dictionary(dict)
	var keys = ComponentTypeDefinitionDataKeys
	var type = dict[keys.component_type_key]
	var custom_type = dict[keys.component_custom_type_key]
	var predicate_type = dict[keys.component_predicate_type_key]
	var input_count = dict[keys.component_input_count_key]
	var output_count = dict[keys.component_output_count_key]
	
	return ComponentTypeDefinition.new(type, custom_type, predicate_type, input_count, output_count)

func validate_component_dictionary(dict: Dictionary) -> void:
	# todo: add keys to validate
	var keys_to_validate = [
	]
	
	for key in keys_to_validate:
		assert(dict.has(key), "Component key missing {_}".format(key))

func load_component(dict: Dictionary) -> Component:
	validate_component_dictionary(dict)
	
	
	#component_type_definition: ComponentTypeDefinition, process_delegate: FuncRef,  inputs: Array, identifier: String = ""
	return Component.new(null, null, [], "")
#	for key in data.keys():
#		if !manually_populate_properties.has(key):
#			node.set(key, data[key])
