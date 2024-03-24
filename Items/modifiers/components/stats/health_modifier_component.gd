extends StatModifier
class_name HealthModifier

func apply_to(user):
	assert(user.stats is CombatantStats)
	var result = apply_action(action, user.stats.health)
	user.stats.health = int(result)
	diff = int(diff)

func get_description(_stats: CombatantStats = null) -> String:
	return action_description("Health")

func undo_from(user):
	assert(user.stats is CombatantStats)
	user.stats.health -= diff
