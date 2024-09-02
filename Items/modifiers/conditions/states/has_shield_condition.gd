extends StateCondition
class_name HasShieldCondition

## Valor con el que comparar.
@export var target: int = 0
## Comparador a utilizar
@export var operator: Operator

## Conecta la comprobación de estado a la señal de cambio de escudo 
func connect_to(p_user: Combatant):
	super.connect_to(p_user)
	p_user.stats.shield_changed.connect(_check_status)
	var stats = p_user.get_stats()
	# Envía la señal con la comprobación del estado inicial
	state_changed.emit(self, _use_comparison_operator(operator, stats.shield, target))
	

## Envía la señal state_changed con el resultado de la comparación 
## cuando el estado cambie
func _check_status(_old, shield):
	state_changed.emit(self, _use_comparison_operator(operator, shield, target))

func get_description():
	return _get_comparison_description(operator, "Shield", target)
