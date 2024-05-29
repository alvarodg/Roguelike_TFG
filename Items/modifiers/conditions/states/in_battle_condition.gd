extends StateCondition
class_name InBattleCondition

func connect_to(p_user: Player):
	super.connect_to(p_user)
	p_user.started_battle.connect(_on_battle_start)
	p_user.ended_battle.connect(_on_battle_end)

func _on_battle_start():
	state_changed.emit(self, true)

func _on_battle_end():
	state_changed.emit(self, false)

func get_description():
	return "in Battle"
