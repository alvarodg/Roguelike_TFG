extends Modifier
class_name StrengthModifier

@export var strength: int

func _init(p_strength: int = 0):
	strength = p_strength
	
func apply_to(user):
	assert(user.stats is CombatantStats)
	user.stats.strength += strength

func get_description(combatant: Combatant = null) -> String:
	return "%+d Strength" % strength
