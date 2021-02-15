extends Object
class_name Runner

var inputs: Array = []
var gates: Array = []
var input_count: int
var output_count: int

func add_gate(steps: ExecutionSteps) -> void:
	gates.append(steps)

func _init(input_count: int, output_count: int):
	self.input_count = input_count
	self.output_count = output_count
	
func run() -> void:
	#todo: change to return array for output values
	pass
	
func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass
