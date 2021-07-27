extends Node

const gate_predicate_func: String = "predicate"

var and_predicate := funcref(AndGate.new(), gate_predicate_func)
var not_predicate := funcref(NotGate.new(), gate_predicate_func)
var pass_through_predicate := funcref(PassThroughGate.new(), gate_predicate_func)

func resolve(gate_predicate_type: int) -> FuncRef:
	assert(Enums.is_gate_predicate_type_valid(gate_predicate_type),
	"Unsupported gate predicate type: %s" % gate_predicate_type)
	
	match gate_predicate_type:
		Enums.GatePredicateType.AND:
			return and_predicate
		Enums.GatePredicateType.NOT:
			return not_predicate
		Enums.GatePredicateType.PASS_THROUGH:
			return pass_through_predicate
		_:
			#handles UNDEFINED
			assert("UNDEFINED gate predicate type")
			return null
