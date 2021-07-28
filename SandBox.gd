extends GraphEdit

const GRAPH_NODE = preload("res://Scenes/CustomGraphNode.tscn")
const GRAPH_NODE_CLOSE_EVENT = "graph_node_close"

onready var add_gate_button = $AddDefinitionHBox/AddDefinitionButton
onready var gate_name_line_edit = $AddDefinitionHBox/DefinitionNameLineEdit
onready var toolbox = $"Toolbox"

func _ready():
	self.right_disconnects = true
	toolbox.connect("gate_clicked", self, "on_gate_clicked")
	OS.low_processor_usage_mode = true
	hook_controller()
	load_persisted_data()

func hook_controller() -> void:
	var hook_errors = 0
	hook_errors |= ComponentController.connect("type_definition_added", self, "_on_type_definition_added")
	hook_errors |= ComponentController.connect("type_definition_removed", self, "_on_type_definition_removed")
	hook_errors |= ComponentController.connect("component_added", self, "_on_component_added")
	hook_errors |= ComponentController.connect("component_removed", self, "_on_component_removed")
	assert(hook_errors == OK)

func load_persisted_data() -> void:
	# remove each node in node group: n.queue_free(), so when populated via load, we don't double up
	TreeHelper.remove_persisted_nodes()
	ComponentController.load()

func _on_type_definition_added(type_definition: ComponentTypeDefinition) -> void:
	pass

func _on_type_definition_removed(type_definition: ComponentTypeDefinition) -> void:
	pass
	
func _on_component_added(component: Component) -> void:
	var graph_node = create_node_from_component(component)
	move_graph_node_to_mouse(graph_node)
	
func _on_component_removed(component: Component) -> void:
	pass
	
func process_gate_name_submitted() -> void:
	var input = gate_name_line_edit.text.to_upper()
	gate_name_line_edit.text = ""
	add_gate_button.disabled = true
	$Toolbox.add_gate(input)

func on_gate_clicked(component_type: int, type_uid: int) -> void:
	var type_def: ComponentTypeDefinition = ComponentController.get_type_definition(component_type, type_uid)
	var component = ComponentFactory.create_component(type_def)
	ComponentController.add_component(component)

func move_graph_node_to_mouse(node: GraphNode) -> void:
	var node_size_halved = node.rect_size / 2.0
	var location = get_local_mouse_position() - node_size_halved
	node.offset = location

func is_name_valid(text) -> bool:
	return text != ""

func _on_AddDefinitionButton_button_up() -> void:
	process_gate_name_submitted()
	
func _on_DefinitionNameLineEdit_text_entered(new_text) -> void:
	if is_name_valid(new_text):
		process_gate_name_submitted()
	
func _on_DefinitionNameLineEdit_text_changed(new_text) -> void:
	add_gate_button.disabled = !is_name_valid(new_text)

# connection list entry example:
# { from_port: 0, from: "GraphNode name 0", to_port: 1, to: "GraphNode name 1" }
const TO_NODE_FIELD_ID: String = "to"
const TO_PORT_FIELD_ID: String = "to_port"

func is_graph_node_input_slot_populated(node_name: String, slot_index: int):
	var list = self.get_connection_list()
	
	for entry in list:
		if entry[TO_NODE_FIELD_ID] == node_name && entry[TO_PORT_FIELD_ID] == slot_index:
			return true
			
	return false

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot) -> void:
	if !is_graph_node_input_slot_populated(to, to_slot):
		var hook_errors = connect_node(from, from_slot, to, to_slot)
		assert(hook_errors == OK)

func on_graph_node_closed(node: GraphNode):
	node.disconnect(GRAPH_NODE_CLOSE_EVENT, self, "on_graph_node_closed")
	remove_child(node)

func create_node_from_component(component: Component) -> CustomGraphNode:
	var node: CustomGraphNode = GRAPH_NODE.instance()
	node.intialise(component)
	var hook_errors = node.connect(GRAPH_NODE_CLOSE_EVENT, self, "on_graph_node_closed")
	assert(hook_errors == OK, "Unable to hoook to event: on_graph_node_closed")
	add_child(node)
	return node

func _on_GraphEdit_tree_exiting():
	# child nodes seem to already be leaving the tree in this event
	print("_on_GraphEdit_tree_exiting")

func _on_SaveButton_pressed():
	ComponentController.save()

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
#	self.right_disconnects 
	self.disconnect_node(from, from_slot, to, to_slot)
