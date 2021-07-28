extends HBoxContainer

var and_type_def_uid
var not_type_def_uid
const MIN_GATE_BUTTON_WIDTH := 50

signal gate_clicked (name, input_count, output_count)

func add_definiton_button(uid: int, name: String) -> void:
	var button = create_definition_button(name)
	$".".add_child(button)
	print("%s added", name)
	
func create_definition_button(name) -> Button:
	# TODO: change to be reactive
	var gate_button = Button.new()
	gate_button.text = name
	gate_button.rect_min_size = Vector2(MIN_GATE_BUTTON_WIDTH, 0)
	gate_button.connect("button_up", self, "process_gate_button_press", [name])
	return gate_button

func _ready():
	and_type_def_uid = ComponentController.get_and_type_definition_uid()
	not_type_def_uid = ComponentController.get_not_type_definition_uid()

func _on_AndButton_button_up():
	emit_gate_clicked(Enums.ComponentType.GATE, and_type_def_uid)

func _on_NotButton_button_up():
	emit_gate_clicked(Enums.ComponentType.GATE, not_type_def_uid)

func emit_gate_clicked(component_type: int, type_uid: int):
	emit_signal("gate_clicked", component_type, type_uid)
