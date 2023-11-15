extends SkillData
class_name AttackSkillData

@export var damage: int = 0
@export var hits: int = 1

func _init():
	pass

func get_description() -> String:
	var description: String = str(damage)
	if hits > 1:
		description += " x "+str(hits)
	description += " Damage"
	return description
