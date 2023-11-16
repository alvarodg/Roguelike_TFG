extends Control

signal finished

@onready var skill_grid = %SkillGrid
@onready var turn_manager: TurnManager = preload("res://Battle/resources/TurnManager.tres")
@onready var combatants: Combatants = preload("res://Battle/resources/Combatants.tres")
@onready var end_turn_button = %EndTurnButton
@onready var enemy_position = %EnemyPosition
@onready var base_enemy = preload("res://Battle/enemy.tscn")
#@onready var next_event = preload("res://Events/choice.tscn")
var next_event: EventData
var player: Player
var enemy_stats: EnemyStats
var enemy: Enemy
@onready var player_stats_ui = %PlayerStatsUI
@onready var coin_box = %CoinBox

# Called when the node enters the scene tree for the first time.
func _ready():
	# Posiblemente cambiar el acceso al singleton por una función de setup
	player = RunData.player
	if not enemy_stats is EnemyStats:
		enemy_stats = preload("res://Battle/enemies/WeakEnemyStats.tres")
	# Crea el nuevo enemigo y asigna sus datos
	enemy = base_enemy.instantiate()
	enemy.stats = enemy_stats
	enemy_position.add_child(enemy)
	# Asigna los combatientes al recurso
	combatants.enemy = enemy
	combatants.player = player
	# Inicializa las interfaces del jugador
	player_stats_ui.setup(player)
	coin_box.setup(player.stats)
	# Conecta señales
	turn_manager.player_turn_started.connect(_on_player_turn_started)
	turn_manager.enemy_turn_started.connect(_on_enemy_turn_started)
	connect_player_signals(player)
	connect_enemy_signals(enemy)
	player.start_battle()
	enemy.start_battle()
	# Asigna el turno al jugador
	turn_manager.turn = turn_manager.Turn.PLAYER_TURN
	
func setup_enemy(p_enemy_stats: EnemyStats):
	enemy_stats = p_enemy_stats

func set_new_enemy(p_enemy_stats: EnemyStats):
	if combatants.enemy is Enemy:
		combatants.enemy.queue_free()
	enemy = base_enemy.instantiate()
	enemy.stats = p_enemy_stats
	combatants.enemy = enemy
	connect_enemy_signals(combatants.enemy)
	enemy_position.add_child(enemy)

func connect_enemy_signals(p_enemy: Enemy):
	p_enemy.died.connect(_on_Enemy_died)
	p_enemy.turn_finished.connect(_on_Enemy_turn_finished)
	
func connect_player_signals(_player: Player):
	pass
	
func _on_Enemy_died():
	print("Died")
	end_battle()
	
func end_battle():
	skill_grid.hide()
	end_turn_button.hide()
	print("You won!")
	if next_event is EventData:
		var next_scene = next_event.instantiate_scene()
		get_parent().add_child(next_scene) 
		hide()
		await next_scene.finished
	finished.emit()
	queue_free()

func _on_player_turn_started():
	player.start_turn()
	skill_grid.show()
	end_turn_button.show()
	
func _on_enemy_turn_started():
	if not combatants.enemy is Enemy:
		end_battle()
	else:
		skill_grid.hide()
		end_turn_button.hide()
		combatants.enemy.start_turn()

func _on_EndTurnButton_pressed():
	turn_manager.set_turn(TurnManager.Turn.ENEMY_TURN)

func _on_Enemy_turn_finished():
	turn_manager.set_turn(TurnManager.Turn.PLAYER_TURN)


func _on_DebugButton_pressed():
	set_new_enemy(EnemyStats.new())
