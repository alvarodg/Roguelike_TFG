extends Node
class_name Enemy

signal turn_finished
signal died
signal health_changed(value)

@onready var combatants = load("res://Battle/resources/Combatants.tres")

@onready var sprite = %Sprite
@onready var enemy_stats_ui = %EnemyStatsUI

var ui_data: EnemyUIData
var stats: EnemyStats
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(stats)
	target = combatants.player
	sprite.texture = ui_data.sprite
	stats.setup()
	stats.start_battle()
	enemy_stats_ui.setup(stats)
	
func setup(p_ui_data: EnemyUIData, p_stats: EnemyStats):
	ui_data = p_ui_data
	# Duplica stats para que se puedan reutilizar.
	stats = p_stats.duplicate()
	connect_to_stat_signals(stats)
	
func set_new_stats(new_stats: EnemyStats):
	stats = new_stats.duplicate()
	enemy_stats_ui.setup(stats)
	connect_to_stat_signals(stats)
	
func connect_to_stat_signals(p_stats):
	p_stats.died.connect(_on_death)


func start_battle():
	stats.start_battle()

func start_turn():
	target = combatants.player
	stats.start_turn()
	act()
	turn_finished.emit()

func act():
	# Implementación mínima, a mejorar. TEMPORAL.
	target.stats.take_damage(stats.damage)

func _on_death():
	died.emit()
