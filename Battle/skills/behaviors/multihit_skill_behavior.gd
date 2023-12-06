extends SkillBehavior
class_name MultihitSkillBehavior

@export var damage: int = 0
@export var hits: int = 1

func use(_user, target, _coins):
	for i in range(hits):
		target.stats.take_damage(damage)

func get_description() -> String:
	var description: String = ""
	# Descripción de daño
	description += str(damage)
	if hits > 1:
		description += " x "+str(hits)
	description += " Damage"
	return description
