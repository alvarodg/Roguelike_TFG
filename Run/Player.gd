extends Combatant
class_name Player


signal coins_changed
signal coin_flipped(coin)
signal ended_battle

signal started_taking_damage
signal finished_taking_damage

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

var taking_damage: bool = false : set = set_taking_damage
var in_damage_queue: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	RunData.player = self
	stats.coin_count_changed.connect(_on_Stats_coin_count_changed)
	stats.died.connect(_on_Stats_died)
	stats.setup()
	create_coin_data(stats.coin_count)
	# Para no volver a incluir el equipo por defecto si está cargando partida
	if equipment_list.size() == 0:
		for equipment in default_equipment:
			if equipment != null:
				equip(equipment)
				# Necesita que CollectionContainer se inicialice antes que Player, TEMPORAL
				# Sustituir por señal
#				if equipment in RunData.collections.equipments.list:
#					RunData.collections.remove_equipment(equipment)
	default_equipment = []
	reset_coins()
	
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
	started_turn.emit()

func end_turn():
	stats.end_turn()
	clear_ephemeral_coins()
	
func start_battle():
	stats.start_battle()
	reset_coins()
	started_battle.emit()

func end_battle():
	stats.end_battle()
	clear_coins()
	ended_battle.emit()

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
		var coin_instance = coin.create_coin_instance()
		coin_instance.flipped.connect(_on_Coin_flipped)
		coins.append(coin_instance)
	coins_changed.emit(coins)

func create_coin_data(amount: int):
	coin_data = []
	for i in range(amount):
		coin_data.append(default_coin)

func clear_ephemeral_coins():
	var to_delete: Array[Coin] = []
	to_delete = coins.filter(func(x: Coin): return x.is_ephemeral)
	for coin in to_delete:
		coins.erase(coin)
		coin.queue_free()

func clear_coins():
	for coin in coins:
		if coin != null:
			coin.queue_free()
	coins = []

func equip(equipment: Equipment):
	equipment.attach_to(self)
	equipment_list.append(equipment)
	equipment.setup()
	equipment_changed.emit(equipment_list)
	EventBus.equipment_equipped.emit(equipment)

# Guarda coin_count datos de monedas. No se considera poder perder monedas en esta implementación.
func _on_Stats_coin_count_changed(value):
	if coin_data.size() < value:
		for i in range(value - coin_data.size()):
			coin_data.append(default_coin)

# Emite la señal died cuando la recibe de stats.
func _on_Stats_died():
	died.emit()

func _on_Coin_flipped(coin):
	coin_flipped.emit(coin)

func set_taking_damage(value):
	if taking_damage != value:
		if value:
			started_taking_damage.emit()
		else:
			finished_taking_damage.emit()
	taking_damage = value
	

# TEMPORAL
func take_damage(amount: int):
#	if taking_damage:
#		await get_tree().create_timer(0.6).timeout
#		taking_damage = false
##		await finished_taking_damage
#	taking_damage = true
	stats.take_damage(amount)
#	await get_tree().create_timer(0.6).timeout
#	taking_damage = false

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
#		print(skill_list[i].resource_path)
	save_dict.merge(skill_dict)
	var equip_dict = {}
	for i in range(equipment_list.size()):
		equip_dict["equipment%02d" % i] = equipment_list[i].resource_path
#		print(equipment_list[i].resource_path)
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
		var equipment = load(data)
		equipment_list.append(equipment)
		equipment.connect_to(self)
	else:
		set(parameter, data)
