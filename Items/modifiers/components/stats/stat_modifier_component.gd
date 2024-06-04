extends Modifier
class_name StatModifier

## enum de acciones para modificar el valor de la estadística
## ADD: Sumar
## MULT: Multiplicar
## SET: Asignar
enum Action {ADD, MULT, SET}
## Magnitud de la acción 
## (se redondeará en la implementación de la subclase si fuera necesario)
@export var magnitude: float
## Acción a aplicar
@export var action: Action
## Diferencia entre el valor antes y después de aplicar el modificador
## (para deshacer la aplicación)
var diff: float

## Constructor
func _init(p_magnitude: float = 0, p_action: Action = Action.ADD):
	magnitude = p_magnitude
	action = p_action

## Aplica el modificador a un usuario (a implementar en subclases)
func apply_to(_user):
	pass

## Deshace el modificador de un usuario (a implementar en subclases)
func undo_from(_user):
	pass

## Genera la descripción del modificador (a implementar en subclases)
func get_description(_stats: CombatantStats = null) -> String:
	return ""

## Aplica la acción al valor value
func apply_action(value):
	var result: float
	if action == Action.ADD:
		result = value + magnitude
	elif action == Action.MULT:
		result = value * magnitude
	elif action == Action.SET:
		result = magnitude
	diff = result - value
	return result
	
# Devuelve la descripción de la acción para el parámetro param_name
func action_description(param_name: String):
	if action == Action.ADD:
		# Comprobación de formato para int o float
		var test_int = int(magnitude)
		if magnitude == test_int:
			return "%+d %s" % [magnitude, param_name]
		else:
			return "%+.2f %s" % [magnitude, param_name]
	elif action == Action.MULT:
		if magnitude < 1 and magnitude > 0:
			return "Lose %s%% of %s" % [(1-magnitude)*100, param_name]
		elif magnitude > 1:
			return "Increase %s by %s%%" % [param_name, (magnitude-1)*100]
		else:
			return "Multiply %s by %s" % [param_name, magnitude]
	else:
		return "Set %s to %d" % [param_name, magnitude]

# Deshace la acción del valor value (DEPRECATED)
#func undo_action(value):
#	if action == Action.ADD:
#		return value - magnitude
#	elif action == Action.MULT:
#		return value / magnitude
#	elif action == Action.SET:
#		return magnitude
