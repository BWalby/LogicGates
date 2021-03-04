extends Object
class_name Persistence

# files are stored under the resource path res://, are commonly read-only
# the user path user://, is intended for persistent data
# this maps to directory: 
# ~/.local/share/godot/app_userdata/Name on macOS and Linux
# %APPDATA%/Name on Windows

# sample code for saving nodes by group and a line in the file each:
#	https://docs.godotengine.org/en/3.2/tutorials/io/saving_games.html#saving-and-reading-data

static func save(file_path: String) -> void:
	var data_file = File.new()
	data_file.open(file_path, File.WRITE)
	
	var definition_dicts = get_group_node_data_dicts(TreeHelper.ic_definition_tag)
	var ic_dicts = get_group_node_data_dicts(TreeHelper.ic_tag)
	
	# generate dict for each node in node group, to_json it, store on separate lines
	for data_dict in definition_dicts:
		data_file.store_line(to_json(data_dict))

	for data_dict in ic_dicts:
		data_file.store_line(to_json(data_dict))
	
	data_file.close()

static func get_group_node_data_dicts(group_tag: String) -> Array:
	var nodes = TreeHelper.get_nodes_in_group(group_tag)
	var dictionaries = []
	for node in nodes:
		if node.is_in_group(TreeHelper.persisted_tag):
			var node_data = generate_data_dict(node)
			dictionaries.append(node_data)
	
	return dictionaries

static func generate_data_dict(node: Node) -> Dictionary:
	assert(TreeHelper.has_generate_data_dict_method(node), ("node is missing required method: %s" % TreeHelper.load_from_data_dict_method_name))
	return node.call(TreeHelper.generate_data_dict_method_name)

# example of a line in data.save:
#{
#	"filename":"res://Scenes/GraphNode.tscn",
#	"metadata":
#	{
#		"input_count":2,
#		"output_count":1
#	},
#	"offset_x":420,
#	"offset_y":280,
#	"parent":"/root/GraphEdit",
#	"title":"AND"
#}

static func load(file_path: String) -> Array:
	var loaded_data = []
	var data_file = File.new()
	
	if not data_file.file_exists(file_path):
		#TODO: operation feedback to user
		return loaded_data
		
	# remove each node in node group: n.queue_free(), so when populated via load, we don't double up
	TreeHelper.remove_persisted_nodes()
	
	data_file.open(file_path, File.READ)
	
	while data_file.get_position() < data_file.get_len():
		var line = data_file.get_line()
		var data_dict = parse_json(line)
		loaded_data.append(data_dict)
		
	return loaded_data
