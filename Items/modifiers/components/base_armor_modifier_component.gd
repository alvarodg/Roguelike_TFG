extends Modifier
class_name BaseArmorModifier

@export var base_armor: int

func _init(p_base_armor: int = 0):
	base_armor = p_base_armor
	
func apply_to(user):
	assert(user.stats is CombatantStats)
	user.stats.base_armor += base_armor

func get_description(combatant: Combatant = null) -> String:
	return "%+d Base Armor." % base_armor
