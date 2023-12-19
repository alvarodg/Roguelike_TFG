extends Modifier
class_name BaseShieldModifier

@export var base_shield: int

func apply_to(user):
	assert(user.stats is CombatantStats)
	user.stats.base_shield += base_shield

func get_description(combatant: Combatant = null) -> String:
	return "%+d Base Shield." % base_shield
