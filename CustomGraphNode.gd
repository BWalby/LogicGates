extends GraphNode

class_name CustomGraphNode

signal graph_node_close(node)

var input_count: int
var output_count: int

func setup(title_text: String, inputs: int, outputs: int):
	title = title_text
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
		#may not need these 2:
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		
		"input_count": input_count,
		"output_count": output_count,
		"title": title,
		TreeHelper.offset_x_key: self.offset.x,
		TreeHelper.offset_y_key: self.offset.y
	}
