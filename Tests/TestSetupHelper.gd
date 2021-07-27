class_name TestSetupHelper
extends Object

static func create_and_component_type_defintion() -> ComponentTypeDefinition:
	return ComponentTypeDefinition.new(Enums.ComponentType.GATE, Enums.GatePredicateType.AND, 2, 1, "AND", 1)

static func create_not_component_type_defintion() -> ComponentTypeDefinition:
	return ComponentTypeDefinition.new(Enums.ComponentType.GATE, Enums.GatePredicateType.NOT, 1, 1, "NOT", 2)
