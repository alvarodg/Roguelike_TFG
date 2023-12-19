extends Modifier
class_name ArmorModifier

@export var armor: int
@export var action: Action

func _init(p_armor: int = 0):
	armor = p_armor
	
func apply_to(user):
	assert(user.stats is CombatantStats)
	user.stats.armor = apply_action(action, user.stats.armor, armor)

func get_description(combatant: Combatant = null) -> String:
	return action_description(action, "Armor", armor)
