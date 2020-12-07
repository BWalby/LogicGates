extends ColorRect

onready var add_gate_button = $AddGateHBox/AddGateButton
onready var gate_name_textbox = $AddGateHBox/GateNameTextBox
onready var toolbox = $"Toolbox"

# Called when the node enters the scene tree for the first time.
func _ready():
	toolbox.connect("gate_clicked", self, "create_gate_node")

func _on_AddGateButton_button_up():
	var input = gate_name_textbox.text.to_upper()
	gate_name_textbox.text	= ""
	$Toolbox.add_gate(input)

func _on_GateNameTextBox_text_changed():
	add_gate_button.disabled = gate_name_textbox.text == ""

func create_gate_node(name: String):
	print("adding node: " + name)
	var scene = load("res://IC.tscn")
	var gate_node: IC = scene.instance()
	
	gate_node.set_gate_name(name)
	gate_node.anchor_top = 0.5
	gate_node.anchor_bottom = 0.5
	gate_node.anchor_left = 0.5
	gate_node.anchor_right = 0.5
	add_child(gate_node)
