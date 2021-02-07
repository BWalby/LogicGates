extends Node

const persisted_tag := "Persisted"
const ic_definition_tag := "ICDefinition"
const ic_tag := "IC"
const generate_data_dict_method_name := "generate_data_dict"
const load_from_data_dict_method_name := "load_from_data_dict"


func remove_nodes_by_group_tag(group_tag: String) -> void:
	var nodes = get_tree().get_nodes_in_group(group_tag)
	
	for node in nodes:
		node.queue_free()

func remove_persisted_nodes() -> void:
	remove_nodes_by_group_tag(persisted_tag)

func get_nodes_in_group(group_tag: String) -> Array:
	return get_tree().get_nodes_in_group(group_tag)

func list_nodes(root_node: Node = null) -> void:
	root_node = get_tree().current_scene if root_node == null else root_node
	
	var children = root_node.get_children()
	
	if children.size() < 1:
		return
		
	for child in children:
		print(child.get_path())
		print()
		
		list_nodes(child)

func instantiate_node_from_filename_value(data_dict: Dictionary) -> Node:
	var filename = data_dict[DataKeys.filename_key]
	return load(filename).instance()

func has_load_method(node: Node) -> bool:
	return node.has_method(self.load_from_data_dict_method_name)
	
func has_generate_data_dict_method(node: Node) -> bool:
	return node.has_method(self.generate_data_dict_method_name)
