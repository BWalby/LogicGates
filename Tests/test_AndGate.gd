extends "res://addons/gut/test.gd"

var theory_inline_data = [
	[false, false, false],
	[true, false, false],
	[false, true, false],
	[true, true, true]
]

func test_and_gate(params=use_parameters(theory_inline_data)):
	var result = AndGate.new().predicate([params[0], params[1]])
	var expected = [params[2]]

	assert_typeof(result, TYPE_ARRAY)
	assert_eq(result, expected)
