extends GraphNode

const INIT_COLOUR: Color = Color.white
const ON_COLOUR: Color = Color.green
const OFF_COLOUR: Color = Color.red

var states = [false, false, false, false]

func _ready():
	init_slots()
	
func init_slots():
	for i in range(states.size()):
		var state = states[i]
		setup_output_slot(i, map_state_to_colour(state))

func toggle_state(index: int) -> bool:
	states[index] = !states[index]
	return states[index]

func setup_output_slot(index: int, colour: Color):
	set_slot(index, false, -1, Color.pink, true, 0, colour)

func set_output_state(index: int):
	var state = toggle_state(index)
	setup_output_slot(index, map_state_to_colour(state))
	
func map_state_to_colour(state) -> Color:
	return ON_COLOUR if state else OFF_COLOUR

func _on_InputAButton_pressed():
	set_output_state(0)

func _on_InputBButton_pressed():
	set_output_state(1)

func _on_InputCButton_pressed():
	set_output_state(2)

func _on_InputDButton_pressed():
	set_output_state(3)
