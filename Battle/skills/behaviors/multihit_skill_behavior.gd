extends SkillBehavior
class_name MultihitSkillBehavior

@export var damage: int = 0
@export var hits: int = 1

func use(user, target, _coins):
	assert(user.stats is CombatantStats and target.stats is CombatantStats)
	for i in range(hits):
		target.stats.take_damage(user.stats.strength + damage)

func get_description() -> String:
	var description: String = ""
	# Descripción de daño
	description += str(damage)
	if hits > 1:
		description += " x "+str(hits)
	description += " Damage"
	return description
