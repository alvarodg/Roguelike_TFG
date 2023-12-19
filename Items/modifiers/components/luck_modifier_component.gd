extends Modifier
class_name LuckModifier

@export var luck: float

func _init(p_luck: float = 0):
	luck = p_luck
	
func apply_to(user):
	assert(user.stats is PlayerStats)
	user.stats.base_luck += luck

func get_description(combatant: Combatant = null) -> String:
	return "%+.2f Base Luck." % luck
