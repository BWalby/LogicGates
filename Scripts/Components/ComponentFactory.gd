extends Node


func create_component(component_type_def: ComponentTypeDefinition, uid: int = 0, identifier: String = "") -> Component:
	var predicate = GatePredicateHelper.resolve(component_type_def.predicate_type)
	
	if uid == 0:
		uid = Uid.create()
	
	return Component.new(component_type_def, predicate, uid, identifier)
		
# func create_input_component(value: bool, identifier: String = "") -> Component:
# 	var uid = Uid.create()
# 	return InputComponent.new(value, uid, identifier)

# func create_pass_through_component(size: int, uid: int = 0, identifier: String = "") -> Component:
# 	var pass_through_type_def = ComponentTypeDefinition.new(Enums.ComponentType.PASS_THROUGH, Enums.GatePredicateType.PASS_THROUGH, size, size)
# 	return create_component(pass_through_type_def, uid, identifier)
