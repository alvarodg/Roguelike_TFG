extends ModifierComponent
class_name HealthModifier

@export var max_health: int
@export var health: int

func apply_to(user):
	assert(user.stats is CombatantStats)
	user.stats.max_health += max_health
	user.stats.health += health
