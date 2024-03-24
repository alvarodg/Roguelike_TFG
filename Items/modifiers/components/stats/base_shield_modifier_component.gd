extends StatModifier
class_name BaseShieldModifier

func apply_to(user):
	assert(user.stats is CombatantStats)
	var result = apply_action(user.stats.base_shield)
	user.stats.base_shield = int(result)
	diff = int(diff)

func get_description(_stats: CombatantStats = null) -> String:
	return action_description("Base Shield")

func undo_from(user):
	assert(user.stats is CombatantStats)
	user.stats.base_shield -= diff
