extends EventScene
class_name CoinBattle

var loss_screen = "res://Menus/loss_screen.tscn"

@onready var turn_manager: TurnManager = preload("res://Battle/resources/TurnManager.tres")
@onready var combatants: Combatants = preload("res://Battle/resources/Combatants.tres")

@onready var end_turn_button = %EndTurnButton
@onready var enemy_position = %EnemyPosition
@onready var player_skill_ui = %PlayerSkillUI
@onready var player_stats_ui = %PlayerStatsUI
@onready var coin_box = %CoinBox

#var player: Player
var enemy_data: EnemyData
var enemy: Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	await get_tree().process_frame
	assert(enemy_data is EnemyData)
	print("Starting")
	# Crea el nuevo enemigo a partir de sus datos
	enemy = enemy_data.create_enemy_instance()
	enemy_position.add_child(enemy)
	# Asigna los combatientes al recurso
	combatants.enemy = enemy
	combatants.player = player
	# Inicializa las interfaces del jugador
	player_skill_ui.setup(player, coin_box)
	player_stats_ui.setup(player)
	# Ejecuta las funciones de inicio de batalla de los combatientes
	player.start_battle()
	enemy.start_battle()
	# Inicializa la interfaz de monedas del jugador después de iniciar batalla
	# (Orden importante para asegurarse de que no queden monedas no deseadas en el jugador)
	coin_box.setup(player)
	# Conecta señales
	turn_manager.player_turn_started.connect(_on_player_turn_started)
	turn_manager.enemy_turn_started.connect(_on_enemy_turn_started)
	connect_player_signals(player)
	connect_enemy_signals(enemy)
#	coin_box.about_to_flip_coins.connect(_on_coins_about_to_flip)
#	coin_box.finished_flipping_coins.connect(_on_coins_finished_flipping)
	# Asigna el turno al jugador
	turn_manager.turn = turn_manager.Turn.PLAYER_TURN
	EventBus.battle_started.emit()
#	coin_box.flip_coins()
	
	
func initialize(p_player: Player, data: BattleEventData):
	super.initialize(p_player, data)
	enemy_data = data.enemy_data
	
#func set_new_enemy(p_enemy_stats: EnemyStats):
#	if combatants.enemy is Enemy:
#		combatants.enemy.queue_free()
#	enemy = base_enemy.instantiate()
#	enemy.stats = p_enemy_stats
#	combatants.enemy = enemy
#	connect_enemy_signals(combatants.enemy)
#	enemy_position.add_child(enemy)

func connect_enemy_signals(p_enemy: Enemy):
	p_enemy.about_to_die.connect(_on_Enemy_about_to_die)
	p_enemy.died.connect(_on_Enemy_died)
	p_enemy.turn_finished.connect(_on_Enemy_turn_finished)
	
func connect_player_signals(p_player: Player):
	p_player.died.connect(_on_Player_died)
#	p_player.started_waiting.connect(_on_Player_started_waiting)
#	p_player.finished_waiting.connect(_on_Player_finished_waiting)
	p_player.bankrupt.connect(_on_Player_bankrupt)
	p_player.started_flipping_coins.connect(_block_input)
	p_player.finished_flipping_coins.connect(_allow_input)
	
func _on_Enemy_about_to_die():
	player_skill_ui.block_input()
	end_turn_button.disabled = true

func _on_Enemy_died():
	print("Died")
	end_battle()

# Si el jugador se declara en bancarrota (no tiene monedas al principio de un turno), pierde.
func _on_Player_bankrupt():
	print("Bankrupt!")
	_on_Player_died()

# Esta implementación considera que solo se puede perder en combate, ¿mover a Player?
func _on_Player_died():
	print("You lost!")
	RunData.delete_save(true)
	get_tree().change_scene_to_file(loss_screen)

func _on_Player_started_waiting():
	_block_input()
	end_turn_button.disabled = true
	
func _on_Player_finished_waiting():
#	_allow_input()
	end_turn_button.disabled = false
#	coin_box.flip_coins()

func end_battle():
	player_skill_ui.hide()
	end_turn_button.hide()
	player.end_battle()
	print("You won!")
	coin_box.empty()
	EventBus.battle_finished.emit()
	finish()

func _on_player_turn_started():
	player.start_turn()
	player_skill_ui.show()
	end_turn_button.show()
	
func _on_enemy_turn_started():
	player.end_turn()
	if not combatants.enemy is Enemy:
		end_battle()
	else:
#		player_skill_ui.hide()
#		end_turn_button.hide()
		_block_input()
		combatants.enemy.start_turn()

func _block_input():
	player_skill_ui.block_input()
	coin_box.block_input()
	end_turn_button.disabled = true
	
func _allow_input():
	player_skill_ui.allow_input()
	coin_box.allow_input()
	end_turn_button.disabled = false

func _on_EndTurnButton_pressed():
	turn_manager.set_turn(TurnManager.Turn.ENEMY_TURN)

func _on_Enemy_turn_finished():
	_allow_input()
	turn_manager.set_turn(TurnManager.Turn.PLAYER_TURN)

#func _on_coins_about_to_flip():
#	player_skill_ui.block_input()
#
#func _on_coins_finished_flipping():
#	player_skill_ui.allow_input()
