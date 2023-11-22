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
func _use():
	pass

func get_coin_cost():
	return data.cost

func get_skill_name():
	return data.name

func get_description():
	return "This is an empty skill"
