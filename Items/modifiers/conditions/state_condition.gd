extends Condition
class_name StateCondition

## Envía una señal con su propia referencia y si se está cumpliendo
## la condición o no cada vez que cambie.
signal state_changed(state_ref, value)

## enum de operadores, que permite seleccionar la comparación a realizar
## para estados en los que se aplique.
enum Operator {LOWER_THAN, LOWER_OR_EQUAL, EQUAL, GREATER_OR_EQUAL, GREATER_THAN}

## Conecta el estado a su usuario (implementar en subclases)
func connect_to(p_user):
	super.connect_to(p_user)

## Genera la descripción del operador
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

## Usa el operador de comparación y devuelve el resultado
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

## Genera la descripción de la comparación
func _get_comparison_description(operator: Operator, param_text: String, target):
	var user_text = "User" if user == null else user.ui_data.ui_name
	# Si el objetivo es que el valor sea 0
	if target == 0 and (operator == Operator.LOWER_OR_EQUAL or operator == Operator.EQUAL):
		return "%s has no %s" % [user_text, param_text]
	# Si el objetivo es que el valor sea mayor que 0
	elif target == 0 and operator == Operator.GREATER_THAN:
		return "%s has %s" % [user_text. param_text]
	# Si no, genera la descripción
	else:
		return "%s's %s %s %s" % [user_text, param_text, _operator_description(operator), target]
