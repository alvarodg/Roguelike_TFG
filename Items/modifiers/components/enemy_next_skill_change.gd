extends Modifier
class_name NextSkillModifier

@export var skill: SkillData
@export var replace: bool = false
@export var secret: bool = false

func apply_to(enemy: Enemy):
	if replace:
		enemy.remove_upcoming_skill(enemy.upcoming_skills.front())
	enemy.add_upcoming_skill(skill, false)
	_finish()

func get_description(stats: CombatantStats = null):
	var does = ("Replaces the next skill to be used" if replace 
				else "Adds a new skill to the top of the list")
	var connector = " with:\n" if replace else ":\n"
	return does if secret else does + connector + skill.get_description(stats)
