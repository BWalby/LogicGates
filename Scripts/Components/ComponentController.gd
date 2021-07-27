extends Object
class_name ComponentController

var predicate_helper := GatePredicateHelper.new()
var factory := ComponentFactory.new(predicate_helper)
var type_definitions: Dictionary = {}
var components: Dictionary = {}
const and_definition_name = "AND"
const not_definition_name = "NOT"
signal custom_definition_added(type_definition)
signal custom_definition_removed(type_definition)
signal component_added(component)
signal component_removed(component)

func _init():
	var and_type_def = ComponentTypeDefinition.new(Enums.ComponentType.GATE, Enums.GatePredicateType.AND, 
		2, 1, 1, and_definition_name)
	var not_type_def = ComponentTypeDefinition.new(Enums.ComponentType.GATE, Enums.GatePredicateType.NOT, 
		1, 1, 2, not_definition_name)
	add_definition(and_type_def)
	add_definition(not_type_def)
	Uid.set_seed_value = 2

func add_definition(definition: ComponentTypeDefinition) -> void:
	type_definitions[definition.uid] = definition
	emit_signal("custom_definition_added", definition)
	
func remove_definition(definition: ComponentTypeDefinition) -> void:
	if type_definitions.erase(definition):
		emit_signal("custom_definition_removed", definition)

func create_component(component_type: int, type_uid: int) -> void:
	var type_def = get_type_definition(component_type, type_uid)

	if type_def == null:
		return
	
	var component = factory.create_component(type_def)
	add_component(component)

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

	return LoadStrategy.load(dict)	

func save(file_path: String) -> void:
	var dictionaries = generate_component_dictionaries()
	# TODO: use real versioning
	Persistence.save_dictionaries(file_path, "1.0.0", dictionaries)

func generate_component_dictionaries() -> Array:
	var dictionaries = []
	for component in self.components:
		dictionaries.append(SaveStrategy.generate_data_dict(component))

	return dictionaries

func get_type_definition(component_type: int, type_def_uid: int) -> ComponentTypeDefinition:
	assert(component_type == Enums.ComponentType.GATE && type_def_uid < 1, "UID must be greater than 0")

	match component_type:
		Enums.ComponentType.GATE:
			assert(type_definitions.has(type_def_uid), "Custom type definition does not exist: '%s'" % type_def_uid)
			return type_definitions[type_def_uid]
		Enums.ComponentType.INPUT:
			assert(true, "TODO: NOT SURE HERE")
			return null
		_:
			assert(true, "Unsupported type definition UID")
			return null


func get_type_definition_by_name(type_def_name: String) -> ComponentTypeDefinition:
	for key in type_definitions:
		var definition = type_definitions[key]
		if definition.name == type_def_name:
			return definition
	
	return null

func get_and_type_definition_uid() -> int:
	var definition = get_type_definition_by_name(and_definition_name)
	return definition.uid

func get_not_type_definition_uid() -> int:
	var definition = get_type_definition_by_name(not_definition_name)
	return definition.uid