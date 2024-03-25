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
	

func undo_action(value):
	if action == Action.ADD:
		return value - magnitude
	elif action == Action.MULT:
		return value / magnitude
	elif action == Action.SET:
		return magnitude

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
