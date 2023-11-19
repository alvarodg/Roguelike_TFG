extends Node
class_name Player

@export var stats: PlayerStats : set = set_stats
@export var ui_data: PlayerUIData
@export var skill_list: Array[SkillData]
@export var default_equipment: Array[Equipment]
var equipment_list: Array[Equipment]
var load_dict: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	RunData.player = self
	stats.setup()
	# Para no volver a incluir el equipo por defecto si está cargando partida
	if equipment_list.size() == 0:
		for equipment in default_equipment:
			equip(equipment)
			# Necesita que CollectionContainer se inicialice antes que Player, TEMPORAL?
			if equipment in RunData.collections.equipments.list:
				RunData.collections.remove_equipment(equipment)
	default_equipment = []

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
	# Podría simplificarse el guardado/cargado de habilidades y equipo, pero esto conserva el orden.
	var skill_dict = {}
	for i in range(skill_list.size()):
		skill_dict["skill%02d" % i] = skill_list[i].resource_path
		print(skill_list[i].resource_path)
	save_dict.merge(skill_dict)
	var equip_dict = {}
	for i in range(equipment_list.size()):
		equip_dict["equipment%02d" % i] = equipment_list[i].resource_path
		print(equipment_list[i].resource_path)
	save_dict.merge(equip_dict)
	return save_dict
	
func data_load(parameter, data):
	# TEMPORAL, cambiar la función de cargado o la forma de obtener el diccionario
	var empty_stats = PlayerStats.new()
	var saved_stats_keys = empty_stats.to_save_dict().keys()
	var skill_regex: RegEx = RegEx.new()
	var equip_regex: RegEx = RegEx.new()
	skill_regex.compile("skill\\d+")
	equip_regex.compile("equipment\\d+")
	# Si el parámetro forma parte de PlayerStats
	if parameter in saved_stats_keys:
		# Lo guarda para cargarlo luego
		load_dict[parameter] = data
		# Si load_dict tiene todos los parámetros de PlayerStats, los carga.
		# (Comprueba por tamaño porque las listas no tienen el mismo orden)
		if load_dict.keys().size() == saved_stats_keys.size():
			stats.load_save_dict(load_dict)
			load_dict = {}
	# Si el parámetro coincide con el regex para habilidades o equipo, los añade a su respectiva lista
	elif skill_regex.search(parameter):
		skill_list.append(load(data))
	elif equip_regex.search(parameter):
		equipment_list.append(load(data))
	else:
		set(parameter, data)

func equip(equipment: Equipment):
	equipment.attach_to(stats)
	equipment_list.append(equipment)
