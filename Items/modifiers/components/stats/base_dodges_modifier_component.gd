extends StatModifier
class_name BaseDodgesModifier

func apply_to(user):
	assert(user.stats is CombatantStats)
	var result = apply_action(user.stats.base_dodges)
	user.stats.base_dodges = int(result)
	diff = int(diff)
	_finish()
	
func get_description(_stats: CombatantStats = null) -> String:
	return action_description("Base Dodges")

func undo_from(user):
	assert(user.stats is CombatantStats)
	user.stats.base_dodges -= diff
