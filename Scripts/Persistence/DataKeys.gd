class_name DataKeys

const id_key := "id" # works as a title in the UI component
const uid_key := "uid"
const input_uids_key := "input_uids"
const pos_x_key := "pos_x"
const pos_y_key := "pos_y"
const type_definition_uid_key = "type_definition_uid"

var auto_generate_data_keys = [
	id_key,
	uid_key,
	input_uids_key
]

var data_keys = auto_generate_data_keys + [
  type_definition_uid_key,
  pos_x_key,
  pos_y_key
]
