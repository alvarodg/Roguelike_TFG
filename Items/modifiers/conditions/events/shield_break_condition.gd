extends EventCondition
class_name ShieldBreakCondition

func connect_to(p_user):
	super.connect_to(p_user)
	p_user.stats.shield_broke.connect(_check_met)

func get_description():
#	var user_text = "User" if user == null else user.ui_data.ui_name
#	return "%s's Shield breaks" % user_text
	return _generate_description()

func _generate_description():
	return "Shield breaks" + super._generate_description()
