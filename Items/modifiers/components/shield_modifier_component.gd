extends Modifier
class_name ShieldModifier

@export var shield: int

func apply_to(user):
	assert(user.stats is CombatantStats)
	user.stats.shield += shield

func get_description(combatant: Combatant = null) -> String:
	return "%+d Shield." % shield
