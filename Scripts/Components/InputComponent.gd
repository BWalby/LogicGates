class_name InputComponent
extends Component

const gate_predicate_func = "forward_input_value_to_results"
const input_type_def_name = "INPUT"
var input_value: bool

var process_delegate = funcref(self, gate_predicate_func)
# TODO: investigate this, something seems wrong, based on counts always being fixed to 1
var component_type_definition = ComponentTypeDefinition.new(Enums.ComponentType.INPUT, Enums.GatePredicateType.UNEDEFINED, 1, 1, input_type_def_name)

# empty array for array, as there are no input components, just an input value
func _init(initial_value: bool, uid: int, identifier: String = "").(component_type_definition, process_delegate, uid, identifier):
  self.input_value = initial_value

func update_input_value(new_value: bool) -> void:
  input_value = new_value

func forward_input_value_to_results(_input: Array) -> Array:
  return [self.input_value]
