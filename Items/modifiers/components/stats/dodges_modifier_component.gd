extends StatModifier
class_name DodgesModifier

func apply_to(user):
	assert(user.stats is CombatantStats)
	var result = apply_action(user.stats.dodges)
	user.stats.dodges = int(result)
	diff = int(diff)
	_finish()

func get_description(_stats: CombatantStats = null) -> String:
	return action_description("Dodges")

func undo_from(user):
	assert(user.stats is CombatantStats)
	user.stats.dodges -= diff
