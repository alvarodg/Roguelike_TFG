extends Modifier
class_name StatModifier

enum Action {ADD, MULT, SET}
## Magnitud de la acción a aplicar a la estadística (se redondeará si fuera necesario).
@export var magnitude: float
## Acción a realizar en la estadística. (Añadir, multiplicar, asignar)
@export var action: Action
var diff: float

func _init(p_magnitude: float = 0, p_action: Action = Action.ADD):
	magnitude = p_magnitude
	action = p_action

func apply_to(_user):
	pass

func get_description(_stats: CombatantStats = null) -> String:
	return ""

func apply_action(action: Action, value):
	var result: float
	if action == Action.ADD:
		result = value + magnitude
	elif action == Action.MULT:
		result = value * magnitude
	elif action == Action.SET:
		result = magnitude
	diff = result - value
	return result
	

func undo_action(action: Action, value):
	if action == Action.ADD:
		return value - magnitude
	elif action == Action.MULT:
		return value / magnitude
	elif action == Action.SET:
		return magnitude

func action_description(param_name: String):
	if action == Action.ADD:
		return "%+d %s" % [magnitude, param_name]
	elif action == Action.MULT:
		return "x %f.2 %s" % [magnitude, param_name]
	else:
		return "Set %s to %d" % [param_name, magnitude]
