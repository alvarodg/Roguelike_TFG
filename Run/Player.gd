extends Resource
class_name Player

signal health_changed(value)
signal energy_changed(value)
signal out_of_energy
signal died
signal turn_finished

@export var max_health = 80
@export var max_energy = 3
var health: int : set = set_health
var energy: int : set = set_energy

# Called when the node enters the scene tree for the first time.
func _init():
	health = max_health
	energy = max_energy


func start_turn():
	energy = max_energy

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
	if health == 0:
		emit_signal("died")

func set_energy(value):
	energy = clamp(value, 0, max_energy)
	emit_signal("energy_changed", energy)
	if energy == 0:
		emit_signal("out_of_energy")
