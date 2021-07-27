extends Object
class_name ComponentFactory

var predicate_helper: GatePredicateHelper
# var and_type_def = ComponentTypeDefinition.new(Enums.ComponentType.AND, Enums.GatePredicateType.AND, 2, 1)
# var not_type_def = ComponentTypeDefinition.new(Enums.ComponentType.NOT, Enums.GatePredicateType.NOT, 1, 1)

func _init(gate_predicate_helper: GatePredicateHelper):
	self.predicate_helper = gate_predicate_helper
	
func create_component(component_type_def: ComponentTypeDefinition, uid: int = 0, identifier: String = "") -> Component:
	var predicate = predicate_helper.resolve(component_type_def.predicate_type)
	
	if uid == 0:
		uid = Uid.create()
	
	return Component.new(component_type_def, predicate, uid, identifier)

# func create_and_component(identifier: String = "") -> Component:
# 	return create_component(and_type_def, 0, identifier)

# func create_not_component(identifier: String = "") -> Component:
# 	return create_component(not_type_def, 0, identifier)
		
# func create_input_component(value: bool, identifier: String = "") -> Component:
# 	var uid = Uid.create()
# 	return InputComponent.new(value, uid, identifier)

# func create_pass_through_component(size: int, uid: int = 0, identifier: String = "") -> Component:
# 	var pass_through_type_def = ComponentTypeDefinition.new(Enums.ComponentType.PASS_THROUGH, Enums.GatePredicateType.PASS_THROUGH, size, size)
# 	return create_component(pass_through_type_def, uid, identifier)
