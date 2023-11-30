extends Modifier
class_name MaxHealthModifier

@export var max_health: int
@export var fill: bool
var health_mod: HealthModifier

func _init(p_max_health: int = 0):
	max_health = p_max_health
	health_mod = HealthModifier.new(max_health)

func apply_to(user):
	assert(user.stats is CombatantStats)
	user.stats.max_health += max_health
	if fill:
		health_mod.apply_to(user)

func get_description() -> String:
	return "%+d Max Health." % max_health
