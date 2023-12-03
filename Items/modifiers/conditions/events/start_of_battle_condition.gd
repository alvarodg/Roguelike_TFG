extends EventCondition
class_name StartOfBattleCondition

func connect_to(p_user: Player):
	super.connect_to(p_user)
	p_user.started_battle.connect(_on_met)

func get_description():
	return "Battle starts"
