extends StatModifier
class_name LuckModifier

func apply_to(user):
	assert(user.stats is CombatantStats)
	var result = apply_action(user.stats.base_luck)
	user.stats.base_luck = result

func get_description(_stats: CombatantStats = null) -> String:
	return action_description("Base Luck")

func undo_from(user):
	assert(user.stats is CombatantStats)
	user.stats.base_luck -= diff
