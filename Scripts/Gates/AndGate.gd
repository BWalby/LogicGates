extends Gate
class_name AndGate

func predicate(input: Array) -> Array:
	var a = input[0]
	var b = input[1]
	return [a && b]
