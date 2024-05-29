extends Condition
class_name EventCondition

signal met
signal remaining_changed(amount, remaining)

## Cantidad de eventos necesarios para que se de por cumplida la condición
@export var amount: int = 1
## true para reiniciar el contador al principio del turno
@export var restart_per_turn: bool = true
var remaining: int : set = set_remaining

func set_remaining(value):
	remaining = value
	remaining_changed.emit(amount, remaining)

func connect_to(p_user):
	super.connect_to(p_user)
	remaining = amount
	if restart_per_turn:
		p_user.started_turn.connect(_reset)

func _on_met():
	met.emit()

func _check_met():
	remaining -= 1
	if remaining == 0:
		_on_met()
		_reset()

func _reset():
	remaining = amount

func _generate_description():
	return " " + str(amount) + " times" if amount > 1 else ""
