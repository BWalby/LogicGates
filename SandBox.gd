extends GraphEdit

const GRAPH_NODE = preload("res://Scenes/GraphNode.tscn")
const GRAPH_NODE_CLOSE_EVENT = "graph_node_close"
const SAVE_FILE_PATH = "user://data.save"

onready var add_gate_button = $AddGateHBox/AddGateButton
onready var gate_name_line_edit = $AddGateHBox/GateNameLineEdit
onready var toolbox = $"Toolbox"
onready var component_controller := ComponentController.new()

func _ready():
	self.right_disconnects = true
	toolbox.connect("gate_clicked", self, "create_gate_node")
	OS.low_processor_usage_mode = true
	hook_controller()
	load_persisted_data()

func hook_controller() -> void:
	connect("custom_definition_added", component_controller, "on_custom_definition_added")
	connect("custom_definition_removed", component_controller, "on_custom_definition_removed")
	connect("component_added", component_controller, "on_component_added")
	connect("component_removed", component_controller, "on_component_removed")

func on_custom_definition_added(type_definition: ComponentTypeDefinition) -> void:
	pass

func on_custom_definition_removed(type_definition: ComponentTypeDefinition) -> void:
	pass
	
func on_component_added(component: Component) -> void:
	create_node(component)
	
func on_component_removed(component: Component) -> void:
	pass	
	
func process_gate_name_submitted() -> void:
	var input = gate_name_line_edit.text.to_upper()
	gate_name_line_edit.text = ""
	add_gate_button.disabled = true
	$Toolbox.add_gate(input)

func create_gate_node(name: String, input_count: int, output_count: int) -> void:
	var node: CustomGraphNode = GRAPH_NODE.instance()
	node.title = name
	node.setup(input_count, output_count)
	node.connect(GRAPH_NODE_CLOSE_EVENT, self, "on_graph_node_closed")
	add_child(node)
	move_gate_to_mouse(node)

func move_gate_to_mouse(node: GraphNode) -> void:
	var node_size_halved = node.rect_size / 2.0
	var location = get_local_mouse_position() - node_size_halved
	node.offset = location

func is_name_valid(text) -> bool:
	return text != ""

func _on_GateNameLineEdit_text_entered(new_text) -> void:
	if is_name_valid(new_text):
		process_gate_name_submitted()

func _on_AddGateButton_button_up() -> void:
	process_gate_name_submitted()
	
func _on_GateNameLineEdit_text_changed(new_text) -> void:
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
		connect_node(from, from_slot, to, to_slot)

func on_graph_node_closed(node: GraphNode):
	node.disconnect(GRAPH_NODE_CLOSE_EVENT, self, "on_graph_node_closed")
	remove_child(node)

func load_persisted_data() -> void:
	# remove each node in node group: n.queue_free(), so when populated via load, we don't double up
	TreeHelper.remove_persisted_nodes()
	
	var dictionaries = Persistence.load_from_file(SAVE_FILE_PATH)
	# todo: split dictionaries to defs and components
	component_controller.load_definitions(dictionaries)
	component_controller.load_components(dictionaries)


func create_node(component: Component) -> void:
		var node = TreeHelper.instantiate_node_from_filename_value(node_data)
		
		assert(TreeHelper.has_load_method(node), ("node is missing required method: %s" % TreeHelper.load_from_data_dict_method_name))
		node.call(TreeHelper.load_from_data_dict_method_name, node_data)
		
		add_child(node)
		node.connect(GRAPH_NODE_CLOSE_EVENT, self, "on_graph_node_closed")

func save_persisted_nodes() -> void:
	Persistence.save(SAVE_FILE_PATH)

func _on_GraphEdit_tree_exiting():
	# child nodes seem to already be leaving the tree in this event
	print("ello")

func _on_SaveButton_pressed():
	save_persisted_nodes()

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
#	self.right_disconnects 
	self.disconnect_node(from, from_slot, to, to_slot)
