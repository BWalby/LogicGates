extends Gate
class_name NotGate

func predicate(input: Array) -> Array:
	var a = input[0]
	return [!a]
