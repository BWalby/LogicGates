extends Gate
class_name NotGate

func _init().(1, 1):
	pass

func predicate(input: Array) -> Array:
	var a = input[0]
	return [!a]
