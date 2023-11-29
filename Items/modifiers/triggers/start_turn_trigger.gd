extends Trigger
class_name StartTurnTrigger

func apply_to(p_player: Player):
	turn_manager.player_turn_started.connect(_on_triggered)
	super.apply_to(p_player)

func get_description():
	return "Start of Turn:\n" + super.get_description()
