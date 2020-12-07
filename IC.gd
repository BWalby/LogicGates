extends HBoxContainer

class_name IC

export var gate_name: String
onready var label = $"ColorRect/Label"

func _ready():
	label.text = gate_name	
	
func set_gate_name(name: String):
	gate_name = name.to_upper()
	if label != null:
		label.text = gate_name
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
