extends "res://addons/gut/test.gd"

var theory_inline_data = [
	[false, false],
	[true, true]
]

func test_pass_through_gate(params=use_parameters(theory_inline_data)):
	var result = PassThroughGate.new().predicate([params[0]])
	var expected = [params[1]]
	assert_eq(result, expected)
