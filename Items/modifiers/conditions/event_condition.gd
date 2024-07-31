extends Condition
class_name EventCondition

## Señal que se envía cuando ocurre el evento deseado
signal met
## Señal que se envía cuando cambia el número de ocurrencias que quedan
## para que se por cumplido el evento
signal remaining_changed(amount, remaining)

## Cantidad de ocurrencias necesarias para que se de por cumplida la condición
@export var amount: int = 1
## true para reiniciar el contador al principio del turno
@export var restart_per_turn: bool = true
## Contador de ocurrencias pendientes
var remaining: int : set = set_remaining

## Setter de remaining
func set_remaining(value):
	remaining = value
	remaining_changed.emit(amount, remaining)

## Conecta al usuario, conectádose a su señal principio de turno si
## restart_per_turn es true
func connect_to(p_user):
	super.connect_to(p_user)
	remaining = amount
	if restart_per_turn:
		p_user.started_turn.connect(_reset)

## Envía la señal met
func _on_met():
	met.emit()

## Reduce el contador y comprueba si se han dado suficientes ocurrencias.
## Da por cumplida la condición y reinicia el contador si es así.
func _check_met():
	remaining -= 1
	if remaining == 0:
		_on_met()
		_reset()

## Reinicia el contador de ocurrencias necesarias
func _reset():
	remaining = amount

## Genera la descripción de la condición
func _generate_description():
	return " " + str(amount) + " times" if amount > 1 else ""
