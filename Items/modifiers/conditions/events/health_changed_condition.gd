extends EventCondition
class_name HealthChangedCondition

enum Direction {EITHER, LOSE, GAIN}

@export var min_threshold: int = 0
@export var direction: Direction = Direction.EITHER

var user_name: String = "User"

## Conecta a la señal de cambio de vida 
func connect_to(p_user: Combatant):
	super.connect_to(p_user)
	p_user.get_stats().health_changed.connect(_check_health)
	if p_user.get_ui_data() != null:
		user_name = p_user.get_ui_data().ui_name

## Cuenta la ocurrencia si el resultado de la tirada es compatible con facing
func _check_health(old_health, health, _max_health):
	match direction:
		Direction.EITHER:
			if abs(health - old_health) > min_threshold:
				_check_met()
		Direction.LOSE:
			if old_health - health > min_threshold:
				_check_met()
		Direction.GAIN:
			if health - old_health > min_threshold:
				_check_met()
	
func get_description():
	return _generate_description()

func _generate_description():
	#var user_name: String = "User" if user.get_ui_data().ui_name == "" else user.get_ui_data().ui_name
	var desc: String = ""
	var threshold_text = "" if min_threshold==0 else "at least %s " % [min_threshold]
	match direction:
		Direction.EITHER:
			desc += user_name + "'s health changes"
			if min_threshold > 0:
				desc += " by at least " + str(min_threshold)
		Direction.LOSE:
			desc += user_name + " loses " + threshold_text + "health"
		Direction.GAIN:
			desc += user_name + " gains " + threshold_text + "health"
	return desc + super._generate_description()
