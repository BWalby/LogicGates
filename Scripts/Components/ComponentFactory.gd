extends Node

func create_component(component_type_def: ComponentTypeDefinition, uid: int = 0, identifier: String = "") -> Component:
	var predicate = GatePredicateHelper.resolve(component_type_def.predicate_type)
	
	if uid == 0:
		uid = Uid.create()
	
	return Component.new(component_type_def, predicate, uid, identifier)
