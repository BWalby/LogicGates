extends Object
class_name Primitives

static func and_gate_predicate(input_1: bool, input_2: bool) -> bool:
	return input_1 && input_2
	
static func or_gate_predicate(input_1: bool, input_2: bool) -> bool:
	return input_1 || input_2
	
static func not_gate_predicate(input: bool) -> bool:
	return not input
