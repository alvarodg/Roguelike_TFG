extends StatModifier
class_name BaseStrengthModifier

func apply_to(user):
	assert(user.stats is CombatantStats)
	var result = apply_action(user.stats.base_strength)
	user.stats.base_strength = int(result)
	diff = int(diff)
	_finish()

func get_description(_stats: CombatantStats = null) -> String:
	return action_description("Base Strength")

func undo_from(user):
	assert(user.stats is CombatantStats)
	user.stats.base_armor -= diff
