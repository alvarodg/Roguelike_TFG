extends Resource
class_name Modifier

enum Action {ADD, SET}

func _init():
	pass

func apply_to(_user):
	pass

func get_description(_combatant: Combatant = null) -> String:
	return ""

func apply_action(action: Action, value, mod):
	if action == Action.ADD:
		return value + mod
	else:
		return mod

func action_description(action: Action, param_name: String, value: int):
	if action == Action.ADD:
		return "%+d %s" % [value, param_name]
	else:
		return "Set %s to %d" % [param_name, value]
