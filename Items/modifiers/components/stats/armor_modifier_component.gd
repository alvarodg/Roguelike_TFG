extends StatModifier
class_name ArmorModifier

func apply_to(user):
	assert(user.stats is CombatantStats)
	var result = apply_action(user.stats.armor)
	user.stats.armor = int(result)
	diff = int(diff)
	_finish()

func get_description(_stats: CombatantStats = null) -> String:
	return action_description("Armor")

func undo_from(user):
	assert(user.stats is CombatantStats)
	user.stats.armor -= diff
