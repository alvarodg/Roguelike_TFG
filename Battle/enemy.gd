extends Node
class_name Enemy

signal turn_finished
signal died
signal health_changed(value)

@onready var enemy_health_bar = $EnemyHealthBar
@onready var combatants = load("res://Battle/resources/Combatants.tres")
@export var max_health = 40
@export var damage = 5
var health: int : set = set_health

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	enemy_health_bar.max_value = max_health
	enemy_health_bar.value = health
	
func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
	enemy_health_bar.value = health
	if health <= 0:
		die()
	
func start_turn():
	act()
	emit_signal("turn_finished") 

func act():
	combatants.player.health -= damage

func die():
	emit_signal("died")
