extends "res://addons/gut/test.gd"

var theory_inline_data = [
	[false, false, false],
	[true, false, true],
	[false, true, true],
	[true, true, true]
]

func test_or_gate(params=use_parameters(theory_inline_data)):
	var result = OrGate.new().predicate([params[0], params[1]])
	var expected = [params[2]]
	assert_eq(result, expected)
