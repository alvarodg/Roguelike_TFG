extends Resource
class_name Skill

signal finished(correctly)

@export var data: SkillData
var user
var target
var coins

func _init(p_data: SkillData = null, p_user = null, p_target = null, p_coins = null):
	data = p_data
	user = p_user
	target = p_target
	coins = p_coins

# Definir use en SkillData?
func use():
	for behavior in data.behaviors:
		behavior.use(user, target, coins)
#	pass

func get_coin_cost():
	return data.cost

func get_skill_name():
	return data.name
#
#func get_description() -> String:
#	var description: String = ""
#	for behavior in data.behaviors:
#		if description != "": description += "\n"
#		description += behavior.get_description()
#	return description
