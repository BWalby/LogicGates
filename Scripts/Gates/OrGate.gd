extends Gate
class_name OrGate

func predicate(input: Array) -> Array:
	var a = input[0]
	var b = input[1]
	return [a || b]
