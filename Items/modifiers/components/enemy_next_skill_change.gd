extends Modifier
class_name NextSkillModifier

@export var skill: SkillData

func apply_to(enemy: Enemy):
	assert(skill is SkillData)
	enemy.add_upcoming_skill(skill, false)
	_finish()

func get_description(stats: CombatantStats = null):
	return "Creates the following skill:\n " + skill.get_description(stats)
