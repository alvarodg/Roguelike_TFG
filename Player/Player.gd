extends Combatant
class_name Player

var loss_screen = "res://Menus/loss_screen.tscn"

signal coins_changed
signal coin_flipped(coin)
signal coin_dropped(coin)
signal coin_count_changed(old, count)
signal bankrupt

signal started_taking_damage
signal finished_taking_damage
signal started_flipping_coins
signal finished_flipping_coins
signal hit(damage, health, max_health)

@export var stats: PlayerStats = PlayerStats.new() : set = set_stats
@export var ui_data: PlayerUIData = PlayerUIData.new()
@export var default_skill_list: SkillList
@export var default_equipment: EquipmentList
#@export var default_equipment: Array[Equipment]
@export var max_skills: int = 6
var skill_list: Array[SkillData]
#var equipment_list: Array[Equipment]
var coins: Array[Coin] : set = set_coins
var coin_data: Array[CoinData]
# Implementación para un único tipo de moneda.
var default_coin = preload("res://Battle/coin_ui/resources/default_coin.tres")
# Para cargar partida
var stats_load_dict: Dictionary = {}
var ui_load_dict: Dictionary = {}

var bias_list: Array[Coin.Facing] = []

var taking_damage: bool = false : set = set_taking_damage
var in_damage_queue: int = 0
var defaults_set: bool = false

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
	if not defaults_set:
		if default_skill_list != null:
			skill_list = default_skill_list.list
		if default_equipment != null:
			for equipment in default_equipment.list:
				if equipment != null:
					equip(equipment)
			await get_tree().process_frame
			_remove_from_pool(default_equipment.list, skill_list)
			defaults_set = true
				# Necesita que CollectionContainer se inicialice antes que Player, TEMPORAL
				# Sustituir por señal
#				if equipment in RunData.collections.equipments.list:
#					RunData.collections.remove_equipment(equipment)
	if default_equipment != null:
		default_equipment.list = []
	reset_coins()
	

func _remove_from_pool(equipments, skills):
	if RunData.collections != null:
		for equipment in equipments:
			if equipment in RunData.collections.equipments.list:
				RunData.collections.remove_all(equipment)
		for skill in skills:
			if skill in RunData.collections.skills.list:
				RunData.collections.remove_all(skill)

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

func get_stats() -> PlayerStats:
	return stats

func get_ui_data() -> PlayerUIData:
	return ui_data

func add_coin(coin: Coin):
	coins.append(coin)
	coins.filter(func(element): return element != null)
	coin.flipped.connect(_on_Coin_flipped)
	coin.dropped.connect(_on_Coin_dropped)
	coins_changed.emit(coins)
	if coin.is_ephemeral and is_inside_tree():
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
	stats.pre_start_turn()
	pre_started_turn.emit()
	stats.start_turn()
	flip_all_coins()
	started_turn.emit()
	if coins.size() == 0:
		bankrupt.emit()
	
func end_turn():
	stats.end_turn()
	clear_ephemeral_coins()
	bias_list = []
#	recover_dropped_coins()
	
func start_battle():
	reset_coins()
	stats.start_battle()
	started_battle.emit()

func end_battle():
	print("battle ended")
	stats.end_battle()
	clear_coins()
	bias_list = []
	ended_battle.emit()
	print("ended signal")

func flip(coin: Coin, speed: float = 1.0, rng: RandomNumberGenerator = RandomNumberGenerator.new()):
	started_flipping_coins.emit()
	var result = coin.flip(stats.base_luck, _get_bias(), rng)
	if is_inside_tree():
		coin.start_spinning()
		await get_tree().create_timer(coin.get_spin_length()/speed).timeout
		coin.stop_spinning()
	if coin in coins:
		coins_changed.emit(coins)
	finished_flipping_coins.emit()
	return result

# TEMPORAL, reorganizar animación
#func logic_flip(coin: Coin, rng: RandomNumberGenerator = RandomNumberGenerator.new()):
	#started_flipping_coins.emit()
	##coin.flipped.connect(_on_Coin_flipped)
	#var result = coin.flip(stats.base_luck, _get_bias(), rng)
	#if coin in coins:
		#coins_changed.emit(coins)
	#finished_flipping_coins.emit()
	#return result

func flip_all_coins(rng: RandomNumberGenerator = RandomNumberGenerator.new()):
	recover_dropped_coins()
	started_flipping_coins.emit()
	for coin in coins:
		if is_instance_valid(coin):
			coin.hide()
			coin.start_spinning()
	print(coins)
	for coin in coins:
		if is_instance_valid(coin):
			coin.show()
			await get_tree().create_timer(coin.get_spin_length()*0.5).timeout
#	await get_tree().create_timer(0.16).timeout
	for coin in coins:
		if is_instance_valid(coin):
			await get_tree().create_timer(coin.get_spin_length()*0.5).timeout
			coin.flip(stats.base_luck, _get_bias(), rng)
			coin.stop_spinning()
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
			coin.set_available()
			
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
	equipment.detach_from(self)
	equipment_list.erase(equipment)
	equipment_changed.emit(equipment_list)

func add_bias(facing: Coin.Facing, count: int = 1):
	for i in count:
		bias_list.append(facing)

func _get_bias() -> Coin.Facing:
	var flip_bias: Coin.Facing = Coin.Facing.ANY
	if bias_list.size() > 0:
		flip_bias = bias_list.pop_front()
	return flip_bias

# Guarda coin_count datos de monedas.
func _on_Stats_coin_count_changed(old, value):
	print("changed")
	if coin_data.size() < value:
		for i in range(value - coin_data.size()):
			coin_data.append(default_coin)
	else:
		coin_data = []
		for i in range(value):
			coin_data.append(default_coin)
	coin_count_changed.emit(old, value)

# Emite la señal died cuando la recibe de stats.
func _on_Stats_died():
	died.emit()
	RunData.delete_save(true)
	await get_tree().create_timer(0.5).timeout
	await ScreenTransitions.fade_to_black()
	get_tree().change_scene_to_file(loss_screen)
	ScreenTransitions.fade_from_black()

func _on_Stats_changed(_old = null, _value = null, _other = null):
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
	

func take_damage(amount: int, ignore_shield = false, ignore_armor = false, 
				 ignore_dodges = false, shield_factor = 1.0):
	stats.take_damage(amount, ignore_shield, ignore_armor, ignore_dodges, shield_factor)

func _on_Stats_hit(damage, health, max_health):
	hit.emit(damage, health, max_health)
#	var number = DAMAGE_NUMBER.instantiate()
#	add_child(number)
#	number.setup(damage, battle_position, ui_data.sprite.x, stats.max_health)
#	number.display_and_free()

func save() -> Dictionary:
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"defaults_set" : defaults_set,
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
		equipment.attach_to(self)
	else:
		set(parameter, data)
