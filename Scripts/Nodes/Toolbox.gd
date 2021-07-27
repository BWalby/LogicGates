extends HBoxContainer

var and_type_def_uid
var not_type_def_uid
const MIN_GATE_BUTTON_WIDTH := 50

signal gate_clicked (name, input_count, output_count)

func add_gate(name: String) -> void:
	var button = create_gate_button(name)
	print("adding")
	$".".add_child(button)
	print("added")
	
func create_gate_button(name) -> Button:
	# TODO: change to be reactive
	var gate_button = Button.new()
	gate_button.text = name
	gate_button.rect_min_size = Vector2(MIN_GATE_BUTTON_WIDTH, 0)
	gate_button.connect("button_up", self, "process_gate_button_press", [name])
	return gate_button

func _ready():
	var controller: ComponentController = $Sandbox.component_controller
	and_type_def_uid = controller.get_and_type_definition_uid()
	not_type_def_uid = controller.get_not_type_definition_uid()

func _on_AndButton_button_up():
	emit_gate_clicked(Enums.ComponentType.GATE, and_type_def_uid)

func _on_NotButton_button_up():
	emit_gate_clicked(Enums.ComponentType.GATE, not_type_def_uid)

func emit_gate_clicked(component_type: int, type_uid: int):
	emit_signal("gate_clicked", component_type, type_uid)
