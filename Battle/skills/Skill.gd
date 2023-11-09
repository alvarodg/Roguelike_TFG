extends Resource
class_name Skill

signal finished(correctly)

@export var data: SkillData
var user
var target

func _init(p_data: SkillData = null, p_user = null, p_target = null):
	data = p_data
	user = p_user
	target = p_target

func _use():
	finished.emit(true)

func get_coin_cost():
	return data.cost
