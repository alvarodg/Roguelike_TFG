extends Node
class_name Enemy

signal turn_finished
signal died
signal health_changed(value)

@onready var enemy_stats_ui = %EnemyStatsUI

@onready var combatants = load("res://Battle/resources/Combatants.tres")
@export var stats: EnemyStats
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(stats)
	target = combatants.player
	stats = stats.duplicate()
	stats.setup()
	stats.start_battle()
	enemy_stats_ui.setup(stats)
	stats.died.connect(_on_death)
	
	
func set_new_stats(new_stats: EnemyStats):
	stats = new_stats.duplicate()
	enemy_stats_ui.setup(stats)
	connect_to_stat_signals()
	
func connect_to_stat_signals():
	stats.died.connect(_on_death)

#func _on_health_changed(value):
#	enemy_health_bar.value = value

func start_battle():
	stats.start_battle()

func start_turn():
	target = combatants.player
	stats.start_turn()
	act()
	turn_finished.emit()

func act():
	target.stats.take_damage(stats.damage)

func _on_death():
	died.emit()
