extends EventCondition
class_name TurnFinishedCondition

func connect_to(p_user):
	super.connect_to(p_user)
	p_user.turn_finished.connect(_check_met)

func get_description():
	return _generate_description()

func _generate_description():
	return "turn ends" + super._generate_description()
