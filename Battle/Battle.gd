extends Control

signal finished

# TODO: probablemente mover las responsabilidades de UI a otra clase

@onready var skill_grid = %SkillGrid
@onready var turn_manager = preload("res://Battle/resources/TurnManager.tres")
@onready var combatants: Combatants = load("res://Battle/resources/Combatants.tres")
@onready var player_health_bar = %PlayerHealthBar
@onready var energy_label = %EnergyLabel
@onready var end_turn_button = %EndTurnButton
@onready var enemy_position = %EnemyPosition
@onready var enemy_class = preload("res://Battle/enemy.tscn")
var enemy: Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy = enemy_class.instantiate()
	enemy_position.add_child(enemy)
	combatants.enemy = enemy
	combatants.player = RunData.player
	turn_manager.connect("player_turn_started", _on_player_turn_started)
	turn_manager.connect("enemy_turn_started", _on_enemy_turn_started)
	connect_player_signals(combatants.player)
	connect_enemy_signals(combatants.enemy)
	energy_label.text = str(combatants.player.energy) + " Energy"
	player_health_bar.max_value = combatants.player.max_health
	player_health_bar.value = combatants.player.health
	turn_manager.turn = turn_manager.Turn.PLAYER_TURN
	
func set_new_enemy(enemy_class: PackedScene):
	if combatants.enemy is Enemy:
		combatants.enemy.queue_free()
	enemy = enemy_class.instantiate()
	combatants.enemy = enemy
	enemy_position.add_child(enemy)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func connect_enemy_signals(p_enemy: Enemy):
	p_enemy.died.connect(_on_Enemy_died)
	p_enemy.turn_finished.connect(_on_Enemy_turn_finished)
	
func connect_player_signals(player: Player):
	player.energy_changed.connect(_on_Player_energy_changed)
	player.health_changed.connect(_on_Player_health_changed)
	
func _on_Enemy_died():
	end_battle()
	
func end_battle():
	skill_grid.hide()
	end_turn_button.hide()
	print("You won!")
	queue_free()
	EventBus.event_finished.emit()

func _on_player_turn_started():
	combatants.player.start_turn()
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

func _on_Player_energy_changed(value):
	if energy_label:
		energy_label.text = str(value) + " Energy"
	
func _on_Player_health_changed(value):
	if player_health_bar:
		player_health_bar.value = value


func _on_DebugButton_pressed():
	set_new_enemy(enemy_class)
