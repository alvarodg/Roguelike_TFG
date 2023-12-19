extends Modifier
class_name BaseDodgesModifier

@export var base_dodges: int

func _init(p_dodges: int = 0):
	base_dodges = p_dodges
	
func apply_to(user):
	assert(user.stats is CombatantStats)
	user.stats.base_dodges += base_dodges

func get_description(combatant: Combatant = null) -> String:
	return "%+d Base Dodges." % base_dodges
