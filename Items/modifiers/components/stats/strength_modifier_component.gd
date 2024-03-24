extends StatModifier
class_name StrengthModifier

func apply_to(user):
	assert(user.stats is CombatantStats)
	var result = apply_action(user.stats.strength)
	user.stats.strength = int(result)
	diff = int(diff)

func get_description(_stats: CombatantStats = null) -> String:
	return action_description("Strength")

func undo_from(user):
	assert(user.stats is CombatantStats)
	user.stats.strength -= diff
