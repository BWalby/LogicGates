extends Object
class_name ComponentSaveStrategy

static func generate_dict(component: Component) -> Dictionary:
  var dict = {}

  for key in DataKeys.auto_generate_data_keys:
	  dict[key] = component[key]

  dict[DataKeys.type_definition_uid_key] = component.type_definition.uid
  dict[DataKeys.pos_x_key] = component.position.x
  dict[DataKeys.pos_y_key] = component.position.y

  return dict
