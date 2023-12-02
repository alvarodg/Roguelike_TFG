extends StateCondition
class_name PercentHealthCondition

@export var percent: float = 0.5
@export var operator: Operator
	
enum Operator {LOWER_THAN, LOWER_OR_EQUAL, EQUAL, GREATER_OR_EQUAL, GREATER_THAN}

func connect_to(user):
	super.connect_to(user)
	assert(user.stats is CombatantStats)
	user.stats.health_changed.connect(_check_met)

func _check_met(_health = null):
	var result: bool = false
	match operator:
		Operator.LOWER_THAN:
			result = user.stats.health < float(user.stats.max_health) * percent
		Operator.LOWER_OR_EQUAL:
			result = user.stats.health <= float(user.stats.max_health) * percent
		Operator.EQUAL:
			result = user.stats.health == int(float(user.stats.max_health) * percent)
		Operator.GREATER_OR_EQUAL:
			result = user.stats.health >= float(user.stats.max_health) * percent
		Operator.GREATER_THAN:
			result = user.stats.health > float(user.stats.max_health) * percent
	state_changed.emit(self, result)
