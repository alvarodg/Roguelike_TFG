extends EventCondition
class_name HitCondition

## Mínimo daño a recibir para que se considere la ocurrencia
@export var min_damage_threshold: int = 0

## Conecta a la señal de golpe recibido del usuario
func connect_to(p_user):
	super.connect_to(p_user)
	p_user.stats.hit.connect(_check_hit)

## Cuenta la ocurrencia si el daño sobrepasa o iguala el límite
func _check_hit(damage = 0):
	if damage >= min_damage_threshold:
		_check_met()

func get_description():
	return _generate_description()

func _generate_description():
	var threshold_text  = "" if min_damage_threshold == 0 else " for %s+ damage" % min_damage_threshold
	return "user is hit" + threshold_text + super._generate_description()
