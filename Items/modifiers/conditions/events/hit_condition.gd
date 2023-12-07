extends EventCondition
class_name HitCondition

@export var amount: int = 1
@export var restart_per_turn: bool = true
var remaining: int

func connect_to(p_user):
	super.connect_to(p_user)
	remaining = amount
	p_user.stats.hit.connect(_check_met)
	if restart_per_turn:
		p_user.started_turn.connect(_reset)
		
func _check_met():
	remaining -= 1
	if remaining == 0:
		_on_met()
		_reset()

func _reset():
	remaining = amount

func get_description():
	var plural = "" if amount == 1 else " %d times" % amount
	return "user is hit%s" % plural
