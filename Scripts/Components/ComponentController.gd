extends Object
class_name ComponentController

var predicate_helper := GatePredicateHelper.new()
var factory := ComponentFactory.new(predicate_helper)
var custom_type_definitions: Dictionary = {}
var components: Dictionary = {}

signal custom_definition_added(type_definition)
signal custom_definition_removed(type_definition)
signal component_added(component)
signal component_removed(component)

func add_definition(definition: ComponentTypeDefinition) -> void:
	custom_type_definitions[definition.uid] = definition
	emit_signal("custom_definition_added", definition)
	
func remove_definition(definition: ComponentTypeDefinition) -> void:
	if custom_type_definitions.erase(definition):
		emit_signal("custom_definition_removed", definition)
	
func add_component(component: Component) -> void:
	components[component.uid] = component
	emit_signal("component_added", component)
	
func remove_component(component: Component) -> void:
	if components.erase(component.uid):
		emit_signal("component_removed", component)

func load(file_path: String) -> void:
	var dictionaries = Persistence.load_dictionaries(file_path)
	# todo: split dictionaries to defs and components
	load_definitions(dictionaries)
	load_components(dictionaries)

func load_definitions(dictionaries: Array) -> void:
	for dictionary in dictionaries:
		var definition = load_definition(dictionary)
		add_definition(definition)

func load_components(dictionaries: Array) -> void:
	for dictionary in dictionaries:
		var component = load_component(dictionary)
		add_component(component)

	for component in self.components:
		resolve_input_steps(component)
	
func resolve_input_steps(component: Component):
	var input_steps = []
	for uid in component.input_uids:
		var child_component = self.components.get(uid)
		assert(child_component != null, "could not retrieve component from uid")
		input_steps.append(child_component)
	
	component.input_steps = input_steps

func validate_definition_dictionary(dict: Dictionary) -> void:
	var keys_to_validate = ComponentTypeDefinitionDataKeys.data_keys
	
	for key in keys_to_validate:
		assert(dict.has(key), "ComponentTypeDefinition key missing: '%s'" % key)

func load_definition(dict: Dictionary) -> ComponentTypeDefinition:
	validate_definition_dictionary(dict)
	var type = dict[ComponentTypeDefinitionDataKeys.component_type_key]
	var type_uid = dict[ComponentTypeDefinitionDataKeys.uid_key]
	var custom_type = dict[ComponentTypeDefinitionDataKeys.component_custom_type_key]
	var predicate_type = dict[ComponentTypeDefinitionDataKeys.component_predicate_type_key]
	var input_count = dict[ComponentTypeDefinitionDataKeys.component_input_count_key]
	var output_count = dict[ComponentTypeDefinitionDataKeys.component_output_count_key]
	
	return ComponentTypeDefinition.new(type, predicate_type, input_count, output_count, type_uid, custom_type)

func validate_component_dictionary(dict: Dictionary) -> void:
	# todo: add keys to validate
	var keys_to_validate = [
		DataKeys.id_key,
		DataKeys.uid_key,
		DataKeys.input_uids_key,
		DataKeys.type_definition_uid_key,
		DataKeys.pos_x_key,
		DataKeys.pos_y_key
	]
	
	for key in keys_to_validate:
		assert(dict.has(key), "Component key missing {_}".format(key))

func load_component(dict: Dictionary) -> Component:
	validate_component_dictionary(dict)

	return LoadStrategy.load(dict, factory, custom_type_definitions)	

func save(file_path: String) -> void:
	var dictionaries = generate_component_dictionaries()
	# TODO: use real versioning
	Persistence.save_dictionaries(file_path, "1.0.0", dictionaries)

func generate_component_dictionaries() -> Array:
	var dictionaries = []
	for component in self.components:
		dictionaries.append(SaveStrategy.generate_data_dict(component))

	return dictionaries
