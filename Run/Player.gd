extends Node
class_name Player

@export var stats: PlayerStats
@export var ui_data: PlayerUIData
@export var skills: Array[SkillData]

# Called when the node enters the scene tree for the first time.
func _ready():
	RunData.player = self
	stats.setup()

func add_skill(skill: SkillData):
	skills.append(skill)

func start_turn():
	stats.start_turn()

func start_battle():
	stats.start_battle()

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
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
