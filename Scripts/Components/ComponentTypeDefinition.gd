extends Object
class_name ComponentTypeDefinition

var type: int # relates to Enums.ComponentType
var uid: int
var name: String
var input_count: int
var output_count: int
var predicate_type: int # relates to Enums.GatePredicateType

func _init(component_type_member: int, gate_predicate_type_member: int, inputs: int, outputs: int, unique_name: String, type_uid: int):
	validate(component_type_member, type_uid, unique_name, gate_predicate_type_member)
	self.uid = type_uid
	self.type = component_type_member
	self.name = unique_name
	self.predicate_type = gate_predicate_type_member
	self.input_count = inputs
	self.output_count = outputs

static func is_custom_type(component_type: int) -> bool:
		return component_type == Enums.ComponentType.GATE

static func validate(component_type_member: int, type_uid: int, unique_name: String, gate_predicate_type_member: int) -> void:
	assert(Enums.is_component_type_valid(component_type_member), "ComponentType %s not supported" % component_type_member)
	assert(unique_name != "", "ComponentTypeDefinition, must provide a unique type name")
	
	if component_type_member == Enums.ComponentType.GATE:
		assert(type_uid > 0, "ComponentTypeDefinition, must provide a type UID")
		
	if component_type_member != Enums.ComponentType.INPUT:
		assert(Enums.is_gate_predicate_type_valid(gate_predicate_type_member) &&
			gate_predicate_type_member != Enums.GatePredicateType.UNEDEFINED,
			"Gate predicate type %s not supported" % gate_predicate_type_member)
