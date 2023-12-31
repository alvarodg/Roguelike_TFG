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

func get_description(combatant: Combatant = null) -> String:
	var description: String = ""
	var string_damage = str(damage) if combatant == null or combatant.stats.strength == 0 else "[color=green]"+str(damage+combatant.stats.strength)+"[/color]"
	# Descripción de daño
	description += string_damage
	if hits > 1:
		description += " x "+str(hits)
	description += " Damage"
	return description
