extends SkillBehavior
class_name HealSkillBehavior

@export var magnitude: int = 0
@export var to_self: bool = true

func use(user, target, _coins):
	if to_self:
		user.stats.health += magnitude
	else:
		target.stats.health += magnitude
	_finish()
	
func get_description(stats: CombatantStats = null):
	var target_text: String = "" if to_self else " to enemy"
	return "Heals %s" % [magnitude, target_text]
