extends EventCondition
class_name StartOfTurnCondition

## true para que se dé por cumplida la condición antes del resto de acciones del principio del turno.
## false para que se realicen primero las demás.
@export var at_beginning: bool = false

func connect_to(p_user):
	assert(p_user is Player or p_user is Enemy)
	super.connect_to(p_user)
	if at_beginning:
		p_user.pre_started_turn.connect(_check_met)
	else:
		p_user.started_turn.connect(_check_met)

func get_description():
	return _generate_description()

func _generate_description():
	return "turn starts" + super._generate_description()
