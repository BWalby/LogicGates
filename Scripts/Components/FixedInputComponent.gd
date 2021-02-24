extends Component
class_name FixedInputComponent

var fixed_input_value: bool

# empty array, as arrays can't be null
func _init(fixed_value: bool).([], null):
	self.fixed_input_value = fixed_value
	
func process() -> Array:
	self.result = [fixed_input_value]
	return self.result
