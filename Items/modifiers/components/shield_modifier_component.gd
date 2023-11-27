extends ModifierComponent
class_name ShieldModifier

@export var base_shield: int
@export var shield: int

func apply_to(user):
	assert(user.stats is CombatantStats)
	user.stats.base_shield += base_shield
	user.stats.shield += shield
