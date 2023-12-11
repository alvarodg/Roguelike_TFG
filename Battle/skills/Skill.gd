extends Resource
class_name Skill

signal finished(correctly)

@export var data: SkillData
var user
var target
var coins

func _init(p_data: SkillData = null, p_user = null, p_target = null, p_coins = []):
	data = p_data
	user = p_user
	target = p_target
	coins = p_coins

# Definir use en SkillData?
func use():
	if data.modifiers_first:
		_use_modifiers()
		_use_behaviors()
	else:
		_use_behaviors()
		_use_modifiers()

func _use_behaviors():
	for behavior in data.behaviors:
		behavior.use(user, target, coins)
	
func _use_modifiers():
	for modifier in data.modifiers:
		modifier.apply_to(user)

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
