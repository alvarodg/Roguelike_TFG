extends CombatantStats
class_name EnemyStats

signal damage_changed

@export var damage: int = 5 : set = set_damage


func _init(p_max_health = 40, p_base_shield = 0, p_base_armor = 0, p_base_dodges = 0, p_damage = 5):
	super(p_max_health, p_base_shield, p_base_armor, p_base_dodges)
	damage = p_damage
	health = max_health

func setup():
	health = max_health
	shield = base_shield
	armor = base_armor
	dodges = base_dodges

func set_health(value):
	health = clamp(value, 0, max_health)
	health_changed.emit(health)
	if health <= 0:
		died.emit()

func set_damage(value):
	damage = value
	damage_changed.emit(damage)
	
