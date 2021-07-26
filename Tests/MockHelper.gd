class_name MockHelper

static func mock_processed_pass_through(mocked_result: Array, identifier: String) -> Component:
	# component_type_definition: ComponentTypeDefinition, process_delegate: FuncRef, persisted_uid: int = 0, identifier: String = ""
	var component = Component.new(null, null, 100, identifier);
	component.result = mocked_result
	return component
