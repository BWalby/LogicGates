extends Component
class_name CombinatorComponent

func combine(inputs: Array) -> Array:
	return inputs

# empty array, as arrays can't be null
func _init(inputs: Array).(inputs, funcref(self, "combine")):
	pass
