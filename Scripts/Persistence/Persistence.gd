extends Object
class_name Persistence

# files are stored under the resource path res://, are commonly read-only
# the user path user://, is intended for persistent data
# this maps to directory: 
# ~/.local/share/godot/app_userdata/Name on macOS and Linux
# %APPDATA%/Name on Windows

# sample code for saving nodes by group and a line in the file each:
#	https://docs.godotengine.org/en/3.2/tutorials/io/saving_games.html#saving-and-reading-data

static func save_dictionaries(file_path: String, dictionaries: Array) -> void:
	var data_file = File.new()
	data_file.open(file_path, File.WRITE)
	
	for data_dict in dictionaries:
		data_file.store_line(to_json(data_dict))

	data_file.close()

static func load_dictionaries(file_path: String) -> Array:
	var loaded_data = []
	var data_file = File.new()
	
	if not data_file.file_exists(file_path):
		#TODO: operation feedback to user
		return loaded_data
		
	data_file.open(file_path, File.READ)
	
	while data_file.get_position() < data_file.get_len():
		var line = data_file.get_line()
		var data_dict = parse_json(line)
		loaded_data.append(data_dict)
		
	return loaded_data
