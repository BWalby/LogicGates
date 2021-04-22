extends Gate
class_name PassThroughGate

func predicate(input: Array) -> Array:
	var results = []
	for value in input:
		results.append(value)
	
	return results
