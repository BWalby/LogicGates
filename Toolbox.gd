extends HBoxContainer

var gates = []
const MIN_GATE_BUTTON_WIDTH := 50

signal gate_clicked (name, input_count, output_count)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_gates() -> void:
	pass
	
func add_gate(name: String) -> void:
	var button = create_gate_button(name)
	print("adding")
	$".".add_child(button)
	print("added")
	
func create_gate_button(name) -> Button:
	var gate_button = Button.new()
	gate_button.text = name
	gate_button.rect_min_size = Vector2(MIN_GATE_BUTTON_WIDTH, 0)
	gate_button.connect("button_up", self, "process_gate_button_press", [name])
	return gate_button


func _on_AndButton_button_up():
	emit_signal("gate_clicked", "AND", 2, 1)
	

func _on_OrButton_button_up():
	emit_signal("gate_clicked", "OR", 2, 1)
