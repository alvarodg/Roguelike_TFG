extends Node
class_name Player

signal died
signal coins_changed
signal equipment_changed

@export var stats: PlayerStats : set = set_stats
@export var ui_data: PlayerUIData
@export var skill_list: Array[SkillData]
@export var default_equipment: Array[Equipment]
@export var max_skills: int = 6
var equipment_list: Array[Equipment]
var coins: Array[Coin] : set = set_coins
var coin_data: Array[CoinData]
# Implementación para un único tipo de moneda.
var default_coin = preload("res://Battle/coin_ui/resources/default_coin.tres")
# Para cargar partida
var stats_load_dict: Dictionary = {}
var ui_load_dict: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	RunData.player = self
	stats.setup()
	stats.coin_count_changed.connect(_on_Stats_coin_count_changed)
	stats.died.connect(_on_Stats_died)
	reset_coins()
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

func add_coin(coin: Coin):
	coins.append(coin)
	coins.filter(func(element): return element != null)
	coins_changed.emit(coins)

func set_coins(new_coins):
	coins = new_coins.filter(func(element): return element != null)
	coins_changed.emit(coins)

func add_skill(skill: SkillData):
	skill_list.append(skill)

func remove_skill(skill: SkillData):
	skill_list.erase(skill)

func start_turn():
	stats.start_turn()
	flip_all_coins()

func end_turn():
	stats.end_turn()
	clear_ephemeral_coins()
	
func start_battle():
	stats.start_battle()
	reset_coins()

func end_battle():
	stats.end_battle()
	clear_coins()

func flip(coin: Coin):
	var result = coin.flip(stats.base_luck)
	if coin in coins:
		coins_changed.emit(coins)
	return result

func flip_all_coins():
	for coin in coins:
		coin.flip(stats.base_luck)
	coins_changed.emit(coins)

func reset_coins():
	clear_coins()
	for coin in coin_data:
		coins.append(coin.create_coin_instance())
	coins_changed.emit(coins)

func clear_ephemeral_coins():
	for coin in coins:
		if coin.is_ephemeral:
			coins.erase(coin)
			coin.queue_free()

func clear_coins():
	for coin in coins:
		if coin != null:
			coin.queue_free()
	coins = []

func equip(equipment: Equipment):
	equipment.attach_to(stats)
	equipment_list.append(equipment)
	equipment_changed.emit(equipment_list)

# Guarda coin_count datos de monedas. No se considera poder perder monedas en esta implementación.
func _on_Stats_coin_count_changed(value):
	if coin_data.size() < value:
		for i in range(value - coin_data.size()):
			coin_data.append(default_coin)

# Emite la señal died cuando la recibe de stats.
func _on_Stats_died():
	died.emit()

func save() -> Dictionary:
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
	}
	var ui_dict = ui_data.to_save_dict()
	save_dict.merge(ui_dict)
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
	var saved_ui_keys = PlayerUIData.save_keys()
	var saved_stats_keys = empty_stats.to_save_dict().keys()
	
	var skill_regex: RegEx = RegEx.new()
	var equip_regex: RegEx = RegEx.new()
	skill_regex.compile("skill\\d+")
	equip_regex.compile("equipment\\d+")
	if parameter in saved_ui_keys:
		ui_load_dict[parameter] = data
		if ui_load_dict.keys().size() == saved_ui_keys.size():
			ui_data.load_dict(ui_load_dict)
			ui_load_dict = {}
	# Si el parámetro forma parte de PlayerStats
	if parameter in saved_stats_keys:
		# Lo guarda para cargarlo luego
		stats_load_dict[parameter] = data
		# Si load_dict tiene todos los parámetros de PlayerStats, los carga.
		# (Comprueba por tamaño porque las listas no tienen el mismo orden)
		if stats_load_dict.keys().size() == saved_stats_keys.size():
			stats.load_save_dict(stats_load_dict)
			stats_load_dict = {}
	# Si el parámetro coincide con el regex para habilidades o equipo, los añade a su respectiva lista
	elif skill_regex.search(parameter):
		skill_list.append(load(data))
	elif equip_regex.search(parameter):
		equipment_list.append(load(data))
	else:
		set(parameter, data)
