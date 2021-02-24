extends Component
class_name FixedInputComponent

var fixed_input_value: bool

# empty array, as arrays can't be null
func _init().([], null):
	pass
	
func Process() -> Array:
	self.result = [fixed_input_value]
	return self.result
