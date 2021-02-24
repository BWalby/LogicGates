extends Object
class_name Component

# can be setup via:
#	funcref(my_node, "my_function")
#	note: this lives in the utilities global @GDScript 	
var process_step: FuncRef
var input_steps: Array
var result := []

func _init(inputs: Array, process_callback: FuncRef):
	self.input_steps = inputs
	self.process_step = process_callback 

func collate_input_results() -> Array:
	var results = []
	for input in self.input_steps:
		results = results + input.result
	
	return results

func all_inputs_are_processed() -> bool:
	for input in self.input_steps:
		if !input.result:
			return false
	
	return true

func process() -> Array:
	assert(all_inputs_are_processed(), "Inputs have not been processed")
	assert(!self.process_step, "Process step cannot be unintialised")
	
	var inputs = collate_input_results()
	
	#todo: test if this works with call_funcv, instead of call_func
	self.result = self.process_step.call_funcv(inputs)
	return self.result
