extends Node

func create_component(component_type_def: ComponentTypeDefinition, uid: int = 0, identifier: String = "") -> Component:
	var predicate = GatePredicateHelper.resolve(component_type_def.predicate_type)
	
	if uid == 0:
		uid = Uid.create()

	if !identifier:
		identifier = component_type_def.name + "_" + str(uid)

	
	return Component.new(component_type_def, predicate, uid, identifier)
