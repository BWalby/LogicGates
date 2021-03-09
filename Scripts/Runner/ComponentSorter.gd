extends Object
class_name ComponentSorter

const pair_index_key := "index"
const pair_component_key := "component"

static func sort_by_child_count_descending(component_a: Dictionary, component_b: Dictionary):
	var a = component_a[pair_component_key] as Component
	var b = component_b[pair_component_key] as Component
	
	if(a.input_steps.size() == b.input_steps.size()):
		var index_a: int = component_a[pair_index_key]
		var index_b: int = component_b[pair_index_key]
		if index_a > index_b:
			return true
		
	if a.input_steps.size() > b.input_steps.size():
		return true
	
	return false
