# Posible reimplementación del sistema de Triggers más extensible, lo mismo no merece la pena.
extends Condition
class_name StateCondition

signal state_changed(state_ref, value)

enum Operator {LOWER_THAN, LOWER_OR_EQUAL, EQUAL, GREATER_OR_EQUAL, GREATER_THAN}

func _comparison_description(operator: Operator):
	match operator:
		Operator.LOWER_THAN:
			return "under"
		Operator.LOWER_OR_EQUAL:
			return "under or at"
		Operator.EQUAL:
			return "at"
		Operator.GREATER_OR_EQUAL:
			return "at or above"
		Operator.GREATER_THAN:
			return "above"

func _use_comparison_operator(operator: Operator, param1, param2):
	match operator:
		Operator.LOWER_THAN:
			return param1 < param2
		Operator.LOWER_OR_EQUAL:
			return param1 <= param2
		Operator.EQUAL:
			return param1 == param2
		Operator.GREATER_OR_EQUAL:
			return param1 >= param2
		Operator.GREATER_THAN:
			return param1 > param2
