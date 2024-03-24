extends StatModifier
class_name ShieldModifier

func apply_to(user):
	assert(user.stats is CombatantStats)
	var result = apply_action(user.stats.shield)
	user.stats.shield = int(result)
	diff = int(diff)

func get_description(_stats: CombatantStats = null) -> String:
	return action_description("Shield")

func undo_from(user):
	assert(user.stats is CombatantStats)
	user.stats.shield -= diff
