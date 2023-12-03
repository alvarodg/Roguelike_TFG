extends StateCondition
class_name HasShieldCondition

@export var target: int = 0

func connect_to(p_user):
	super.connect_to(p_user)
	assert(p_user.stats is CombatantStats)
	p_user.stats.shield_changed.connect(_check_status)
	
func _check_status(shield):
	return shield > target

func get_description():
	if target == 0:
		return "User has Shield."
	else:
		return "User has over %d Shield." % [target]
