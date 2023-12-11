extends EventCondition
class_name TurnFinishedCondition

func connect_to(p_user):
	super.connect_to(p_user)
	p_user.turn_finished.connect(_check_met)

func get_description():
	var user_text = "User" if user == null else user.ui_data.ui_name
	return "%s's turn ends" % user_text
