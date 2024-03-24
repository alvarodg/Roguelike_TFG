extends StatModifier
class_name MaxHealthModifier

@export var fill: bool


func apply_to(user):
	assert(user.stats is CombatantStats)
	var result = apply_action(user.stats.max_health)
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
