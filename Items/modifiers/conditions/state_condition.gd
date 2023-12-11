# Posible reimplementación del sistema de Triggers más extensible, lo mismo no merece la pena.
extends Condition
class_name StateCondition

signal state_changed(state_ref, value)

enum Operator {LOWER_THAN, LOWER_OR_EQUAL, EQUAL, GREATER_OR_EQUAL, GREATER_THAN}

func _operator_description(operator: Operator):
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

func _get_comparison_description(operator: Operator, param_text: String, target):
	var user_text = "User" if user == null else user.ui_data.ui_name
	if target == 0 and (operator == Operator.LOWER_OR_EQUAL or operator == Operator.EQUAL):
		return "%s has no %s" % [user_text, param_text]
	elif target == 0 and operator == Operator.GREATER_THAN:
		return "%s has %s" % [user_text. param_text]
	else:
		return "%s's %s %s %s" % [user_text, param_text, _operator_description(operator), target]
