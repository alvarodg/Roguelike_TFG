extends Node

signal health_changed(value)
signal light_energy_changed(value)
signal dark_energy_changed(value)
signal out_of_ligth_energy
signal out_of_dark_energy
signal died
signal turn_finished
signal coin_flipped(result)

enum {HEADS, TAILS}

@export var stats: PlayerStats
var coins: Array[Coin]
@export var max_energy = 5
@export var base_luck = 0.5

var luck_mod: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
#		"pos_x" : position.x,
#		"pos_y" : position.y,
	}
	var stats_dict = stats.to_save_dict()
	save_dict.merge(stats_dict)
	return save_dict

func data_load(parameter, data):
	# TEMPORAL, cambiar la función de cargado o la forma de obtener el diccionario
	var empty_stats = PlayerStats.new()
	if parameter in empty_stats.to_save_dict().keys():
		stats.set(parameter, data)
	else:
		set(parameter, data)
