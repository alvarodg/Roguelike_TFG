extends Resource
class_name EnemySkillData

@export var ui_data: EnemySkillUIData
@export var behaviors: Array[SkillBehavior]

func get_description() -> String:
	var description: String = ""
	for behavior in behaviors:
		if description != "": description += "\n"
		description += behavior.get_description()
	return description

func create_skill(user, target, coins = []) -> EnemySkill:
	return EnemySkill.new(self, user, target, coins)
