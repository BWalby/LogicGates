extends Node

var current_uid: int = 0

func set_seed_value(uid: int) -> void:
  current_uid = uid;

func create() -> int:
  self.current_uid = self.current_uid + 1
  return self.current_uid
