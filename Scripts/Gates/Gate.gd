extends Object
class_name Gate

var input_count: int
var output_count: int

func _init(input_count: int, output_count: int):
	self.input_count = input_count
	self.output_count = output_count
	
func predicate(input: Array) -> Array:
	return input
