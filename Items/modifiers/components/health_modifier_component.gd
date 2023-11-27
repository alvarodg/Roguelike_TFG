extends Modifier
class_name HealthModifier

@export var health: int

func _init(p_health: int = 0):
	health = p_health
	
func apply_to(user):
	assert(user.stats is CombatantStats)
	user.stats.health += health

func get_description() -> String:
	return "%+d Health." % health
