extends "res://addons/gut/test.gd"

var theory_inline_data = [
	[false, true],
	[true, false]
]

func test_not_gate(params=use_parameters(theory_inline_data)):
	var result = NotGate.new().predicate([params[0]])
	var expected = [params[1]]
	assert_eq(result, expected)
