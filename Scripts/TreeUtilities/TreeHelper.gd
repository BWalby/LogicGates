extends Node

const persisted_tag := "Persisted"
const ic_definition_tag := "ICDefinition"
const ic_tag := "IC"

func get_custom_graph_node(uid: int) -> CustomGraphNode:
	var graph_nodes: Array = get_tree().get_nodes_in_group(ic_tag)
	for graph_node in graph_nodes:
		if graph_node.component.uid == uid:
			return graph_node

	return null

func remove_nodes_by_group_tag(group_tag: String) -> void:
	var nodes = get_tree().get_nodes_in_group(group_tag)
	
	for node in nodes:
		node.queue_free()

func remove_persisted_nodes() -> void:
	remove_nodes_by_group_tag(persisted_tag)

func list_nodes(root_node: Node = null) -> void:
	root_node = get_tree().current_scene if root_node == null else root_node
	
	var children = root_node.get_children()
	
	if children.size() < 1:
		return
		
	for child in children:
		print(child.get_path())
		print()
		
		list_nodes(child)

func add_to_persisted_group(node: Node) -> void:
	node.add_to_group(persisted_tag)

func add_to_ic_group(node: Node) -> void:
	node.add_to_group(ic_tag)
