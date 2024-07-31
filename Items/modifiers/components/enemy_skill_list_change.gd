extends Modifier
class_name SkillListModifier

@export var skill_list: Array[SkillData]
@export var strategy: Enemy.Strategy

func apply_to(enemy: Enemy):
	enemy.replace_available_skills(skill_list)
	enemy.skills = skill_list.duplicate()
	enemy.strategy = strategy
	_finish()	

func get_description(stats: CombatantStats = null):
	return "Replaces the current skill list."
