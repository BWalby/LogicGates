extends Object
class_name ComponentHelper

const gate_predicate_func: String = "predicate"

static func create_or_component(inputs: Array) -> Component:
	var or_gate = OrGate.new()
	return Component.new(inputs, funcref(or_gate, gate_predicate_func))

static func create_and_component(inputs: Array) -> Component:
	var and_gate = AndGate.new()
	return Component.new(inputs, funcref(and_gate, gate_predicate_func))

static func create_not_component(inputs: Array) -> Component:
	var or_gate = NotGate.new()
	return Component.new(inputs, funcref(or_gate, gate_predicate_func))

static func create_nand_component(inputs: Array) -> Component:
	var and_component = create_and_component(inputs)
	return create_not_component([and_component])
