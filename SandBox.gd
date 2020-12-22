extends GraphEdit

const GRAPH_NODE = preload("res://GraphNode.tscn")
const GRAPH_NODE_CLOSE_EVENT = "graph_node_close"

onready var add_gate_button = $AddGateHBox/AddGateButton
onready var gate_name_line_edit = $AddGateHBox/GateNameLineEdit
onready var toolbox = $"Toolbox"

func _ready():
	toolbox.connect("gate_clicked", self, "create_gate_node")
	OS.low_processor_usage_mode = true
	
func process_gate_name_submitted() -> void:
	var input = gate_name_line_edit.text.to_upper()
	gate_name_line_edit.text = ""
	add_gate_button.disabled = true
	$Toolbox.add_gate(input)

func create_gate_node(name: String, input_count: int, output_count: int) -> void:
	var node: CustomGraphNode = GRAPH_NODE.instance()
	node.setup(name, input_count, output_count)
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
