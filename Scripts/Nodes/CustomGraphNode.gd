extends GraphNode

class_name CustomGraphNode

signal graph_node_close(node)

var input_count: int
var output_count: int
var load_strategy = CustomGraphNodeLoadStrategy.new()

func setup(inputs: int, outputs: int):
	self.input_count = inputs
	self.output_count = outputs
	setup_slots(inputs, outputs)
	setup_labels(inputs)

func setup_slots(count: int, outputs: int) -> void:
	for i in count:
		var is_output = i < outputs
		setup_slot(i, is_output)
	
func setup_slot(index: int, is_output: bool) -> void:
	var input_colour := Color.white
	var input_type = 0
	var output_colour = Color.white
	var output_type = 0
	set_slot(index, true, input_type, input_colour, is_output, output_type, output_colour)
	
func setup_labels(inputs: int) -> void:
	for i in inputs:
		var label: Label = Label.new()
		label.text = CharMapper.int_to_char(i)
		add_child(label)

func _on_GraphNode_close_request():
	emit_signal("graph_node_close", self)

func generate_data_dict() -> Dictionary:
	return {
		DataKeys.filename_key : get_filename(),
		DataKeys.parent_key : get_parent().get_path(),

		DataKeys.title_key: title,
		DataKeys.offset_x_key: self.offset.x,
		DataKeys.offset_y_key: self.offset.y,
		
		DataKeys.metadata_key: {
			"input_count": input_count,
			"output_count": output_count
		}		
	}

func load_from_data_dict(data: Dictionary) -> void:
	load_strategy.load(data, self)
	load_strategy.load_meta_data(data, self)
