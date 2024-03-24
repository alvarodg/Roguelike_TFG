extends StatModifier
class_name MaxHealthModifier

@export var fill: bool
#var health_mod: HealthModifier

#func apply_to(user):
#	assert(user.stats is CombatantStats)
#	user.stats.max_health += max_health
#	if fill:
#		health_mod.apply_to(user)
#
#func get_description(stats: CombatantStats = null) -> String:
#	return "%+d Max Health." % max_health

func apply_to(user):
	assert(user.stats is CombatantStats)
	var result = apply_action(action, user.stats.max_health)
	user.stats.max_health = int(result)
	diff = int(diff)
	if fill:
		var health_mod: HealthModifier = HealthModifier.new(magnitude, action)
		health_mod.apply_to(user)

func get_description(_stats: CombatantStats = null) -> String:
	var desc: String = action_description("Max Health")
	if fill:
		desc += (" (Refilling health)")
	return desc
	
func undo_from(user):
	assert(user.stats is CombatantStats)
	user.stats.health -= diff
