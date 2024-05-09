extends Combatant
class_name Player


signal coins_changed
signal coin_flipped(coin)
signal coin_dropped(coin)

signal started_taking_damage
signal finished_taking_damage
signal started_flipping_coins
signal finished_flipping_coins
signal hit(damage)

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

var bias: Coin.Facing = Coin.Facing.ANY

var taking_damage: bool = false : set = set_taking_damage
var in_damage_queue: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	RunData.player = self
#	add_to_group("player")
#	add_to_group("run_persistent")
#	stats.coin_count_changed.connect(_on_Stats_coin_count_changed)
#	stats.died.connect(_on_Stats_died)
	stats.setup()
	connect_stat_signals()
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
	

func connect_stat_signals():
	stats.coin_count_changed.connect(_on_Stats_coin_count_changed)
	stats.died.connect(_on_Stats_died)
	stats.armor_changed.connect(_on_Stats_changed)
	stats.dodges_changed.connect(_on_Stats_changed)
	stats.health_changed.connect(_on_Stats_changed)
	stats.shield_changed.connect(_on_Stats_changed)
	stats.strength_changed.connect(_on_Stats_changed)
	stats.max_health_changed.connect(_on_Stats_changed)
	stats.hit.connect(_on_Stats_hit)
	

func set_stats(new_stats):
	stats = new_stats	
	stats.setup()

func add_coin(coin: Coin):
	coins.append(coin)
	coins.filter(func(element): return element != null)
	coin.flipped.connect(_on_Coin_flipped)
	coin.dropped.connect(_on_Coin_dropped)
	coins_changed.emit(coins)
	if coin.is_ephemeral:
		coin.fade_in()

func set_coins(new_coins):
	coins = new_coins.filter(func(element): return element != null)
	coins_changed.emit(coins)

func add_skill(skill: SkillData):
	skill_list.append(skill)

func remove_skill(skill: SkillData):
	skill_list.erase(skill)

func get_coin_count():
	return stats.coin_count

func start_turn():
	pre_started_turn.emit()
	stats.start_turn()
	flip_all_coins()
	started_turn.emit()

func end_turn():
	stats.end_turn()
	clear_ephemeral_coins()
#	recover_dropped_coins()
	
func start_battle():
	stats.start_battle()
	reset_coins()
	started_battle.emit()

func end_battle():
	print("battle ended")
	stats.end_battle()
	clear_coins()
	ended_battle.emit()
	print("ended signal")

func flip(coin: Coin, rng: RandomNumberGenerator = RandomNumberGenerator.new()):
	started_flipping_coins.emit()
	coin.start_spinning()
	await get_tree().create_timer(0.64).timeout
	coin.stop_spinning()
	var result = coin.flip(stats.base_luck, bias, rng)
	if coin in coins:
		coins_changed.emit(coins)
	finished_flipping_coins.emit()
	return result

# TEMPORAL, reorganizar animación
func logic_flip(coin: Coin, rng: RandomNumberGenerator = RandomNumberGenerator.new()):
	started_flipping_coins.emit()
	var result = coin.flip(stats.base_luck, bias, rng)
	if coin in coins:
		coins_changed.emit(coins)
	finished_flipping_coins.emit()
	return result

func flip_all_coins(rng: RandomNumberGenerator = RandomNumberGenerator.new()):
	# TODO: Reorganizar animación.
	recover_dropped_coins()
	started_flipping_coins.emit()
	for coin in coins:
		coin.hide()
		coin.start_spinning()
	for coin in coins:
		coin.show()
		await get_tree().create_timer(coin.get_spin_length()*0.5).timeout
#	await get_tree().create_timer(0.16).timeout
	for coin in coins:
		await get_tree().create_timer(coin.get_spin_length()*0.5).timeout
		coin.stop_spinning()
		coin.flip(stats.base_luck, bias, rng)
	coins_changed.emit(coins)
	finished_flipping_coins.emit()

func reset_coins():
	clear_coins()
	for coin in coin_data:
		var coin_instance = coin.create_coin_instance()
		coin_instance.flipped.connect(_on_Coin_flipped)
		coin_instance.dropped.connect(_on_Coin_dropped)
		coins.append(coin_instance)
	coins_changed.emit(coins)

func create_coin_data(amount: int):
	coin_data = []
	for i in range(amount):
		coin_data.append(default_coin.duplicate())

func clear_ephemeral_coins():
	var to_delete: Array[Coin] = []
	to_delete = coins.filter(func(x: Coin): return x.is_ephemeral)
	for coin in to_delete:
		coin.fade_out()
		coins.erase(coin)
		coin.queue_free()

func clear_coins():
	for coin in coins:
		if coin != null:
			coin.queue_free()
	coins = []

func get_available_coins():
	var available: Array[Coin] = []
	for coin in coins:
		if coin.status == Coin.Status.AVAILABLE:
			available.append(coin)
	return available

func recover_inserted_coins():
	for coin in coins:
		if coin.status == Coin.Status.INSERTED:
			pass
			
func recover_dropped_coins():
	for coin in coins:
		if coin.status == Coin.Status.DROPPED:
			coin.set_available()

func equip(equipment: Equipment):
	equipment.attach_to(self)
	equipment.broke.connect(_on_equipment_broke)
	equipment_list.append(equipment)
	equipment.setup()
	equipment_changed.emit(equipment_list)
	EventBus.equipment_equipped.emit(equipment)

func unequip(equipment: Equipment):
	equipment_list.erase(equipment)
	equipment_changed.emit(equipment_list)

# Guarda coin_count datos de monedas. No se considera poder perder monedas en esta implementación.
func _on_Stats_coin_count_changed(value):
	if coin_data.size() < value:
		for i in range(value - coin_data.size()):
			coin_data.append(default_coin)

# Emite la señal died cuando la recibe de stats.
func _on_Stats_died():
	died.emit()

func _on_Stats_changed(_old, _value):
	stats_changed.emit(stats)
	
func _on_Coin_flipped(coin):
	coin_flipped.emit(coin)

func _on_Coin_dropped(coin):
	coin_dropped.emit(coin)

func _on_equipment_broke(equipment: Equipment):
	unequip(equipment)


func set_taking_damage(value):
	if taking_damage != value:
		if value:
			started_taking_damage.emit()
		else:
			finished_taking_damage.emit()
	taking_damage = value
	

func take_damage(amount: int, ignore_shield = false, ignore_armor = false, ignore_dodges = false):
	stats.take_damage(amount, ignore_shield, ignore_armor, ignore_dodges)

func _on_Stats_hit(damage):
	hit.emit(damage)
#	var number = DAMAGE_NUMBER.instantiate()
#	add_child(number)
#	number.setup(damage, battle_position, ui_data.sprite.x, stats.max_health)
#	number.display_and_free()

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
