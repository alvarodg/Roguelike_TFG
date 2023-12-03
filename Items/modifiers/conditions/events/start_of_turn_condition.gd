extends EventCondition
class_name StartOfTurnCondition

## true para que se dé por cumplida la condición antes del resto de acciones del principio del turno.
## false para que se realicen primero las demás.
@export var at_beginning: bool = false

func connect_to(p_user: Player):
	super.connect_to(p_user)
	if at_beginning:
		turn_manager.player_turn_started.connect(_on_met)
	else:
		p_user.started_turn.connect(_on_met)

func get_description():
	return "user's turn starts"
