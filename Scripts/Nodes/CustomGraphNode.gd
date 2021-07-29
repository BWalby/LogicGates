class_name CustomGraphNode
extends GraphNode

signal graph_node_close(node)

var component: Component
var load_strategy = CustomGraphNodeLoadStrategy.new()

func intialise(component_model: Component):
	self.component = component_model
	var type_def = component.type_definition
	setup_slots(type_def.input_count, type_def.output_count)
	setup_labels(type_def.input_count)
	setup_title(component.id)
	setup_position(component.position)
	assert(connect("position_changed", component, "on_component_position_changed"),
		"Could not connect to component.position_changed")

func setup_position(position: Vector2) -> void:
	self.offset = position

func setup_slots(count: int, outputs: int) -> void:
	for i in count:
		var is_output = i < outputs
		setup_slot(i, is_output)
	
func setup_slot(index: int, is_output: bool) -> void:
	var input_colour := Color.white
	var input_type = 0
	var output_colour = Color.white
	var output_type = 0
	set_slot(index, true, input_type, input_colour, is_output, output_type, output_colour)
	
func setup_labels(inputs: int) -> void:
	for i in inputs:
		var label: Label = Label.new()
		label.text = CharMapper.int_to_char(i)
		add_child(label)

func setup_title(identifier: String) -> void:
	self.title = identifier

func _on_GraphNode_close_request():
	emit_signal("graph_node_close", self)

func on_component_position_changed(position: Vector2) -> void:
	self.offset = position
	#TODO: propagate this to the Sandbox.gd

func on_GraphNode_offset_changed():
	self.component.position = self.offset
