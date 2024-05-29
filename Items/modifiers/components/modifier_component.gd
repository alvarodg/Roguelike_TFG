extends Resource
class_name Modifier

signal finished(modifier)

#enum Action {ADD, MULT, SET}

func _init():
	pass

func apply_to(_user):
	pass

func _finish():
	finished.emit(self)

func get_description(_stats: CombatantStats = null) -> String:
	return ""
#
#func apply_action(action: Action, value, mod):
#	var result_dict: Dictionary = {}
#	if action == Action.ADD:
#		result_dict["result"] = value + mod
#	elif action == Action.MULT:
#		result_dict["result"] = value * mod
#	elif action == Action.SET:
#		result_dict["result"] = mod
#	result_dict["diff"] = result_dict["result"] - value
#	return result_dict
#
#
#func undo_action(action: Action, value, mod):
#	if action == Action.ADD:
#		return value - mod
#	else:
#		return mod
#
#func action_description(action: Action, param_name: String, value: float):
#	if action == Action.ADD:
#		return "%+d %s" % [value, param_name]
#	elif action == Action.MULT:
#		return "x %f.2 %s" % [value, param_name]
#	else:
#		return "Set %s to %d" % [param_name, value]
