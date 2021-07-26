extends Node

var current_uid: int = 0

func create() -> int:
  self.current_uid = self.current_uid + 1
  return self.current_uid
