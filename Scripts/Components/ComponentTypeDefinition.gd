extends Object
class_name ComponentTypeDefinition

var type: int # relates to Enums.ComponentType
var uid: int
var custom_type: String
var input_count: int
var output_count: int
var predicate_type: int # relates to Enums.GatePredicateType

func _init(component_type_member: int, gate_predicate_type_member: int, inputs: int, outputs: int, type_uid: int = -1, custom_type_name: String = ""):
	validate(component_type_member, type_uid, custom_type_name, gate_predicate_type_member)
	
	self.type = component_type_member
	initialise_uid(component_type_member, type_uid)	
	self.custom_type = custom_type_name
	self.predicate_type = gate_predicate_type_member
	self.input_count = inputs
	self.output_count = outputs

static func is_custom_type(component_type: int) -> bool:
		return component_type == Enums.ComponentType.CUSTOM

func validate(component_type_member: int, type_uid: int, custom_type_name: String, gate_predicate_type_member: int) -> void:
	assert(component_type_member != Enums.ComponentType.UNDEFINED, "ComponentType cannot be undefined")
	assert(Enums.is_component_type_valid(component_type_member), "ComponentType %s not supported" % component_type_member)
	
	if component_type_member == Enums.ComponentType.CUSTOM:
		assert(custom_type_name != "", "Custom ComponentType, must provide a custom type name")
		assert(type_uid > -1, "Custom ComponentType, must provide a type UID")
		
	if component_type_member != Enums.ComponentType.INPUT:
		assert(Enums.is_gate_predicate_type_valid(gate_predicate_type_member) &&
			gate_predicate_type_member != Enums.GatePredicateType.UNEDEFINED,
			"Gate predicate type %s not supported" % gate_predicate_type_member)

func initialise_uid(component_type_member: int, type_uid: int) -> void:
	if component_type_member == Enums.ComponentType.UNDEFINED:
		return

	if !is_custom_type(component_type_member):
		self.uid = self.type
	elif type_uid > 0:
		self.uid = type_uid
	else:
		self.uid = Uid.create()