extends Node
class_name Player

@export var stats: PlayerStats : set = set_stats
@export var ui_data: PlayerUIData
@export var skill_list: Array[SkillData]
var load_dict: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	RunData.player = self
	stats.setup()

func set_stats(new_stats):
	stats = new_stats
	stats.setup()

func add_skill(skill: SkillData):
	skill_list.append(skill)

func start_turn():
	stats.start_turn()

func start_battle():
	stats.start_battle()

func save() -> Dictionary:
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
	}
	var stats_dict = stats.to_save_dict()
	save_dict.merge(stats_dict)
	var event_dict = {}
	for i in range(skill_list.size()):
		event_dict["skill"+str(i)] = skill_list[i].resource_path
		print(skill_list[i].resource_path)
	save_dict.merge(event_dict)
	return save_dict
	
func data_load(parameter, data):
	# TEMPORAL, cambiar la función de cargado o la forma de obtener el diccionario
	var empty_stats = PlayerStats.new()
	var regex: RegEx = RegEx.new()
	regex.compile("skill\\d+")
	# Si el parámetro forma parte de PlayerStats
	if parameter in empty_stats.to_save_dict().keys():
		# Lo guarda para cargarlo luego
		load_dict[parameter] = data
		# Si load_dict tiene todos los parámetros de PlayerStats, los carga.
		# (Comprueba por tamaño porque las listas no tienen el mismo orden)
		if load_dict.keys().size() == empty_stats.to_save_dict().keys().size():
			stats.load_save_dict(load_dict)
			load_dict = {}
	# Si el parámetro coincide con el regex para habilidades, carga la habilidad
	elif regex.search(parameter):
		skill_list.append(load(data))
	else:
		set(parameter, data)
