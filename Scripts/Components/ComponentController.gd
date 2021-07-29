extends Node

var type_definitions: Dictionary = {}
var components: Dictionary = {}

const components_file_path = "user://components.save"
const type_definitions_file_path = "user://defs.save"
const and_definition_uid = 1
const not_definition_uid = 2
const uid_default_seed = 3
const default_type_uids = [and_definition_uid, not_definition_uid]
const pass_through_definition_name = "PASS_THROUGH_"
signal type_definition_added(type_definition)
signal type_definition_removed(type_definition)
signal component_added(component)
signal component_removed(component)

func reinitialise_default_definitions():
	var definitions_to_remove = []
	
	for definition in type_definitions.values():
		if !default_type_uids.has(definition.uid):
			definitions_to_remove.append(definition)

	for definition in definitions_to_remove:
		remove_definition(definition)
	
	type_definitions.clear()
	var and_type_def = ComponentTypeDefinition.new(Enums.ComponentType.GATE, Enums.GatePredicateType.AND, 
		2, 1, "AND", and_definition_uid)
	var not_type_def = ComponentTypeDefinition.new(Enums.ComponentType.GATE, Enums.GatePredicateType.NOT, 
		1, 1, "NOT", not_definition_uid)
	add_definition(and_type_def, false)
	add_definition(not_type_def, false)
	Uid.set_seed_value(uid_default_seed)

func add_definition(definition: ComponentTypeDefinition, notify: bool = true) -> void:
	type_definitions[definition.uid] = definition
	if notify:
		emit_signal("type_definition_added", definition)
	
func remove_definition(definition: ComponentTypeDefinition) -> void:
	if type_definitions.erase(definition):
		emit_signal("type_definition_removed", definition)

func add_component(component: Component) -> void:
	components[component.uid] = component
	emit_signal("component_added", component)
	
func remove_component(component: Component) -> void:
	if components.erase(component.uid):
		emit_signal("component_removed", component)

func load() -> void:
	var type_defs_saved_dict = Persistence.load_dictionaries(type_definitions_file_path)
	var components_saved_dict = Persistence.load_dictionaries(components_file_path)

	reinitialise_default_definitions()
	load_definitions(type_defs_saved_dict)
	load_components(components_saved_dict)
	update_uid_seed_value()

func update_uid_seed_value() -> void:
	var max_uid: int = Uid.get_max_uid([type_definitions.values(), components.values()], uid_default_seed)
	Uid.set_seed_value(max_uid + 1)

func load_definitions(dictionaries: Array) -> void:
	var strategy = ComponentTypeDefinitionLoadStrategy.new()
	for dictionary in dictionaries:
		validate_definition_dictionary(dictionary)
		var definition = strategy.load(dictionary)		
		add_definition(definition)

func load_components(dictionaries: Array) -> void:
	components.clear()

	var strategy = ComponentLoadStrategy.new()
	for dictionary in dictionaries:
		var component = load_component(strategy, dictionary)
		add_component(component)

	for component in self.components.values():
		resolve_input_steps(component)

func load_component(strategy: ComponentLoadStrategy, dict: Dictionary) -> Component:
	validate_component_dictionary(dict)
	var type_def_uid = strategy.load_type_def_uid(dict)
	var type_def = get_type_definition(Enums.ComponentType.GATE, type_def_uid)
	return strategy.load(dict, type_def)		

# TODO: refactor to own input resolver class
func resolve_input_steps(component: Component):
	var input_steps = []
	for uid in component.input_uids:
		var child_component = self.components[uid]
		assert(child_component != null, "could not retrieve component from uid")
		input_steps.append(child_component)
	
	component.input_steps = input_steps

func validate_definition_dictionary(dict: Dictionary) -> void:
	var keys_to_validate = ComponentTypeDefinitionDataKeys.data_keys
	
	for key in keys_to_validate:
		assert(dict.has(key), "ComponentTypeDefinition key missing: '%s'" % key)

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

func save() -> void:
	var type_defs_dict = generate_type_definition_dictionaries()
	var components_dict = generate_component_dictionaries()	
	# TODO: use real versioning
	var version = "1.0.0"
	Persistence.save_dictionaries(type_definitions_file_path, version, type_defs_dict)
	Persistence.save_dictionaries(components_file_path, version, components_dict)

func generate_type_definition_dictionaries() -> Array:
	var strategy = ComponentTypeDefinitionSaveStrategy.new()
	var dictionaries = []
	for type_def in type_definitions.values():
		if default_type_uids.has(type_def.uid):
			continue 
		dictionaries.append(strategy.generate_data_dict(type_def))
	
	return dictionaries

func generate_component_dictionaries() -> Array:
	var strategy = ComponentSaveStrategy.new()
	var dictionaries = []
	for component in components.values():
		dictionaries.append(strategy.generate_dict(component))

	return dictionaries

func get_type_definition(component_type: int, type_def_uid: int) -> ComponentTypeDefinition:
	assert(component_type == Enums.ComponentType.GATE && type_def_uid > 0, "UID must be greater than 0")

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
	return and_definition_uid

func get_not_type_definition_uid() -> int:
	return not_definition_uid

func get_pass_through_definition_uid(size: int) -> int:
	var name = pass_through_definition_name + str(size)
	var definition = get_type_definition_by_name(name)

	if definition == null:
		definition = ComponentTypeDefinition.new(Enums.ComponentType.GATE, Enums.GatePredicateType.PASS_THROUGH, 
		size, size, name, Uid.create())
		add_definition(definition)
	
	return definition	
