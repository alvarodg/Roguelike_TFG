extends Modifier
class_name NextSkillModifier

@export var skill: SkillData

func apply_to(enemy: Enemy):
	enemy.add_upcoming_skill(skill, false)
	

func get_description():
	return "Creates the following skill:\n " + skill.get_description()
