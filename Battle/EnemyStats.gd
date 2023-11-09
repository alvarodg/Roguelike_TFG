extends Resource
class_name EnemyStats

signal died
signal health_changed(value)

@export var max_health: int = 40
@export var damage: int = 5
var health: int : set = set_health

func _init(p_max_health = 40, p_damage = 5):
	max_health = p_max_health
	damage = p_damage
	health = max_health

func setup():
	health = max_health


func set_health(value):
	health = clamp(value, 0, max_health)
	health_changed.emit(health)
	if health <= 0:
		died.emit()
