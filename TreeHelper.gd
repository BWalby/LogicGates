extends Node

const persisted_tag := "Persisted"
const ic_definition_tag := "ICDefinition"
const ic_tag := "IC"
const generate_data_dict_method_name := "generate_data_dict"
const pos_x_key = "pos_x"
const pos_y_key = "pos_y"
const offset_x_key = "offset_x"
const offset_y_key = "offset_y"
const filename_key = "filename"
const parent_key = "parent"
const metadata_key = "metadata"
const manually_populate_properties = [filename_key, parent_key, metadata_key, pos_x_key, pos_y_key, offset_x_key, offset_y_key]

func _ready():
	pass # Replace with function body.

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

func populate_node_from_data(data: Dictionary, node: Node) -> void:
	if data.has_all([offset_x_key, offset_y_key]):
		node.offset = Vector2(data[offset_x_key], data[offset_y_key])
	
	if data.has_all([pos_x_key, pos_y_key]):
		node.position = Vector2(data[pos_x_key], data[pos_y_key])
	
	for key in data.keys():
		if manually_populate_properties.has(key):
			continue
		
		node.set(key, data[key])
