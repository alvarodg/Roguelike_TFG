extends EventCondition
class_name UsedSkillCondition

func connect_to(p_user):
	super.connect_to(p_user)
	p_user.used_skill.connect(_check_met)

func get_description():
	return _generate_description()

func _generate_description():
	return "uses skill" + super._generate_description()
