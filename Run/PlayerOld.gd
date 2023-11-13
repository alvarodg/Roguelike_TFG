extends Resource
class_name Player

signal health_changed(value)
signal light_energy_changed(value)
signal dark_energy_changed(value)
signal out_of_ligth_energy
signal out_of_dark_energy
signal died
signal turn_finished
signal coin_flipped(result)

enum {HEADS, TAILS}

@export var max_health = 80
@export var max_energy = 5
@export var base_luck = 0.5
var health: int : set = set_health
var light_energy: int : set = set_light_energy
var dark_energy: int : set = set_dark_energy
var luck_mod: float = 1

# Called when the node enters the scene tree for the first time.
func _init():
	health = max_health
	light_energy = 0
	dark_energy = 0
	flip_all_coins()
	


func start_turn():
	light_energy = 0
	dark_energy = 0
	flip_all_coins()

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
	if health == 0:
		emit_signal("died")

func set_light_energy(value):
	light_energy = clamp(value, 0, max_energy)
	light_energy_changed.emit(light_energy)
	if light_energy == 0:
		out_of_ligth_energy.emit()

func set_dark_energy(value):
	dark_energy = clamp(value, 0, max_energy)
	dark_energy_changed.emit(dark_energy)
#	emit_signal("energy_changed", dark_energy)
	if dark_energy == 0:
		out_of_dark_energy.emit()
#		emit_signal("out_of_energy")

func get_luck():
	return base_luck * luck_mod

func coin_flip():
	var result = HEADS if get_luck() > randf() else TAILS
	coin_flipped.emit(HEADS)
	return result

func flip_all_coins():
	for i in range(max_energy):
		var flip_result = coin_flip()
		match flip_result:
			HEADS:
				light_energy += 1
			TAILS:
				dark_energy += 1

func to_save_dict() -> Dictionary:
	return {
		"max_health" : max_health,
		"max_energy" : max_energy,
		"health" : health,
		"luck_mod" : luck_mod 
	}
	
func load_save_dict(dict: Dictionary):
	max_health = dict["max_health"]
	max_energy = dict["max_energy"]
	health = dict["health"]
	luck_mod = dict["luck_mod"]
