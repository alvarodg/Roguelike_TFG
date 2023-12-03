extends StateCondition
class_name PercentHealthCondition

@export var percent: float = 0.5
@export var operator: Operator

func connect_to(p_user):
	super.connect_to(p_user)
	assert(p_user.stats is CombatantStats)
	p_user.stats.health_changed.connect(_check_status)

func _check_status(_health = null):
	var result = _use_comparison_operator(operator, user.stats.health, user.stats.max_health * percent)
	state_changed.emit(self, result)

func get_description():
	var operator_text: String = _comparison_description(operator)
	return "User's Health is %s %d%%." % [operator_text, percent*100]
