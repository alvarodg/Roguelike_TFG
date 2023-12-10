extends Condition
class_name EventCondition

signal met
signal remaining_changed(amount, remaining)

@export var amount: int = 1
@export var restart_per_turn: bool = true
var remaining: int

func connect_to(p_user):
	super.connect_to(p_user)
	remaining = amount
	if restart_per_turn:
		p_user.started_turn.connect(_reset)

func _on_met():
	met.emit()

func _check_met():
	remaining -= 1
	remaining_changed.emit(amount, remaining)
	if remaining == 0:
		_on_met()
		_reset()

func _reset():
	remaining = amount
