extends Node

const uid_field_key := "uid"
var current_uid: int = 1

func set_seed_value(uid: int) -> void:
  current_uid = uid;

func create() -> int:
  var result = self.current_uid
  self.current_uid = self.current_uid + 1
  return result
  

func get_max_uid(arrays: Array, fallback_value: int) -> int:
  var max_uid: int = fallback_value

  for array in arrays:
    for element in array:
      max_uid = max(max_uid, element[uid_field_key]) 

  return max_uid