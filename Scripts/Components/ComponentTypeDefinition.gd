extends Object
class_name ComponentTypeDefinition

var type: int
var custom_type: String
var input_count: int
var output_count: int
var predicate_type: int

func _init(component_type_member: int, custom_type_name: String, gate_predicate_type_member: int, inputs: int, outputs: int):
	validate(component_type_member, custom_type_name, gate_predicate_type_member)
	
	self.type = component_type_member
	self.custom_type = custom_type_name
	self.predicate_type = gate_predicate_type_member
	self.input_count = inputs
	self.output_count = outputs

func validate(component_type_member: int, custom_type_name: String, gate_predicate_type_member: int) -> void:
	assert(component_type_member != Enums.ComponentType.UNDEFINED, "ComponentType cannot be undefined")
	assert(Enums.is_component_type_valid(component_type_member), "ComponentType %s not supported" % component_type_member)
	
	if component_type_member == Enums.ComponentType.CUSTOM:
		assert(custom_type_name != "", "Custom ComponentType, must provide a custom type name")
		
	if component_type_member != Enums.ComponentType.INPUT:
		assert(Enums.is_gate_predicate_type_valid(gate_predicate_type_member) &&
			gate_predicate_type_member != Enums.GatePredicateType.UNEDEFINED,
			"Gate predicate type %s not supported" % gate_predicate_type_member)

func generate_data_dict() -> Dictionary:
	var dict = { }
	
	for key in ComponentTypeDefinitionDataKeys.data_keys:
		dict[key] = self[key]
	
	return dict
