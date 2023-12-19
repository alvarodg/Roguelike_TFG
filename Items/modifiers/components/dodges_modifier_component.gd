extends Modifier
class_name DodgesModifier

@export var dodges: int

func _init(p_dodges: int = 0):
	dodges = p_dodges
	
func apply_to(user):
	assert(user.stats is CombatantStats)
	user.stats.dodges += dodges

func get_description(combatant: Combatant = null) -> String:
	return "%+d Dodges." % dodges
