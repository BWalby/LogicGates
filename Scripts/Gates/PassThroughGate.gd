extends Gate
class_name PassThroughGate

func _init().(1, 1):
	pass

func predicate(input: Array) -> Array:
	var first_value = input[0]
	return [first_value]
