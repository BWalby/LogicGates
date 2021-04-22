extends Object
class_name Enums

enum ComponentType { UNDEFINED = -1, INPUT, AND, NOT, PASS_THROUGH, CUSTOM }
enum GatePredicateType { UNEDEFINED = -1, AND, NOT, PASS_THROUGH }

static func is_component_type_valid(input: int) -> bool:
  return ComponentType.values().has(input)

static func is_gate_predicate_type_valid(input: int) -> bool:
  return GatePredicateType.values().has(input)
