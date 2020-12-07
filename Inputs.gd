extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func process_input_press(index: int):
	print("input" + str(index))


func _on_InputButton1_button_up():
	process_input_press(0)

func _on_InputButton2_button_up():
	process_input_press(1)


func _on_InputButton3_button_up():
	process_input_press(2)


func _on_InputButton4_button_up():
	process_input_press(3)
