extends GraphNode

class_name CustomGraphNode

signal graph_node_close(node)

var input_count: int
var output_count: int

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
#	var is_root_node := true;
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
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),

		"title": title,
		TreeHelper.offset_x_key: self.offset.x,
		TreeHelper.offset_y_key: self.offset.y,
		
		TreeHelper.metadata_key: {
			"input_count": input_count,
			"output_count": output_count	
		}		
	}

func setup_from_data(data: Dictionary) -> void:
	var metadata = data[TreeHelper.metadata_key]
	setup(metadata["input_count"], metadata["output_count"])
