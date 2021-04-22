extends Object
class_name ComponentFactory

var predicate_helper: GatePredicateHelper
var and_type_def = ComponentTypeDefinition.new(Enums.ComponentType.AND, "", Enums.GatePredicateType.AND, 2, 1)
var not_type_def = ComponentTypeDefinition.new(Enums.ComponentType.NOT, "", Enums.GatePredicateType.NOT, 1, 1)

func _init(gate_predicate_helper: GatePredicateHelper):
	self.predicate_helper = gate_predicate_helper
	
func create_component(component_type_def: ComponentTypeDefinition, inputs: Array, identifier: String = "") -> Component:
	var predicate = predicate_helper.resolve(component_type_def.predicate_type)
	return Component.new(component_type_def, predicate, inputs, identifier)

func create_and_component(inputs: Array, identifier: String = "") -> Component:
	return create_component(and_type_def, inputs, identifier)

func create_not_component(input: Component, identifier: String = "") -> Component:
	return create_component(not_type_def, [input], identifier)
		
func create_input_component(value: bool, identifier: String = "") -> Component:
	return InputComponent.new(value, identifier)

func create_pass_through_component(inputs: Array, identifier: String = "") -> Component:
	var size = inputs.size()
	var pass_through_type_def = ComponentTypeDefinition.new(Enums.ComponentType.PASS_THROUGH, "", Enums.GatePredicateType.PASS_THROUGH, size, size)
	return create_component(pass_through_type_def, inputs, identifier)
