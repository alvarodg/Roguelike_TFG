extends Modifier
class_name ArmorModifier

@export var armor: int

func _init(p_armor: int = 0):
	armor = p_armor
	
func apply_to(user):
	assert(user.stats is CombatantStats)
	user.stats.base_armor += armor

func get_description() -> String:
	return "%+d Armor" % armor
