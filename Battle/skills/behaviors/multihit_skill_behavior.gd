extends SkillBehavior
class_name MultihitSkillBehavior

@export var damage: int = 0
@export var hits: int = 1

var wait_time: float = 0.5
const slash = preload("res://Battle/skills/animations/slash_animation.tscn")

func use(user, target, _coins):
	assert(user.stats is CombatantStats and target.stats is CombatantStats)
	for i in range(hits):
		if i != 0:
			var animation = slash.instantiate()
			target.add_child(animation)
			animation.global_position = target.battle_position
			target.wait(wait_time)
			await target.finished_waiting
		target.stats.take_damage(user.stats.strength + damage)

func get_description() -> String:
	var description: String = ""
	# Descripción de daño
	description += str(damage)
	if hits > 1:
		description += " x "+str(hits)
	description += " Damage"
	return description
