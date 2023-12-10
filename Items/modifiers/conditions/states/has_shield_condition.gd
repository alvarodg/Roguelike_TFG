extends StateCondition
class_name HasShieldCondition

@export var target: int = 0

func connect_to(p_user):
	super.connect_to(p_user)
	assert(p_user.stats is CombatantStats)
	p_user.stats.shield_changed.connect(_check_status)
	
func _check_status(shield):
	state_changed.emit(self, shield > target)

func get_description():
	var user_text = "User" if user == null else user.ui_data.ui_name
	if target == 0:
		return "%s has a Shield." % user_text
	else:
		return "%s has over %d Shield." % [user_text, target]
