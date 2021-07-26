extends Object
class_name Component

var id: String
var uid: int
var input_uids := []
var input_steps := []
# can be setup via:
#	funcref(my_node, "my_function")
#	note: this lives in the utilities global @GDScript
var process_step: FuncRef
var result := []
var type_definition: ComponentTypeDefinition
var position: Vector2 = Vector2.ZERO setget set_position

signal position_changed(position)

func _init(component_type_definition: ComponentTypeDefinition, process_delegate: FuncRef, persisted_uid: int = 0, identifier: String = ""):
	self.uid = persisted_uid if persisted_uid > 0 else Uid.create()
	self.process_step = process_delegate
	self.id = identifier
	self.type_definition = component_type_definition

func set_position(value):
	position = value
	emit_signal("position_changed", position)

func collate_input_results() -> Array:
	var results = []
	
	for input in self.input_steps:
		results = results + input.result
	
	return results

func all_inputs_are_processed() -> bool:
	for input in self.input_steps:
		if !input.result:
			return false
	
	return true

func process() -> Array:
	assert(self.input_steps != null, "Input steps collection not initialised")
	assert(all_inputs_are_processed(), "Inputs have not been processed")
	assert(self.process_step != null, "Process step cannot be unintialised")
	assert(self.process_step.is_valid(), "Callback parent object no longer exists")
	
	var inputs = collate_input_results()
	self.result = self.process_step.call_func(inputs)
	return self.result
