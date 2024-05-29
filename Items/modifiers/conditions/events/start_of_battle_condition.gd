extends EventCondition
class_name StartOfBattleCondition

func connect_to(p_user):
	super.connect_to(p_user)
	p_user.started_battle.connect(_check_met)

func get_description():
	return _generate_description()

func _generate_description():
	return "Battle starts" + super._generate_description()
