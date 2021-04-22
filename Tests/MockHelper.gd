class_name MockHelper

static func mock_processed_pass_through(mocked_result: Array, identifier: String) -> Component:
	var component = Component.new(null, null, [], identifier);
	component.result = mocked_result
	return component
