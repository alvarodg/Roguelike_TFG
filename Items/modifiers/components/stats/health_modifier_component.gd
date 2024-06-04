extends StatModifier
class_name HealthModifier

func apply_to(user: Combatant):
	var result = apply_action(user.stats.health)
	# Conversión a int
	user.stats.health = int(result)
	diff = int(diff)
	_finish()

func get_description(_stats: CombatantStats = null) -> String:
	return action_description("Health")

func undo_from(user):
	assert(user.stats is CombatantStats)
	user.stats.health -= diff
