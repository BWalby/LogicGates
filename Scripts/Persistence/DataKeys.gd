class_name DataKeys

const id_key := "id" # works as a title in the UI component
const uid_key := "uid"
const input_uids_key := "input_uids"
const pos_x_key := "pos_x"
const pos_y_key := "pos_y"
const type_definition_uid_key = "type_definition_uid"

const auto_generate_data_keys = [
	DataKeys.id_key,
	DataKeys.uid_key,
	DataKeys.input_uids_key,
]

const data_keys = auto_generate_data_keys + [
  DataKeys.type_definition_uid_key,
  DataKeys.pos_x_key,
  DataKeys.pos_y_key
]
