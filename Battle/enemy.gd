extends Node
class_name Enemy

signal turn_finished
signal died
signal health_changed(value)

@onready var enemy_health_bar = %EnemyHealthBar
@onready var damage_label = %DamageLabel
@onready var combatants = load("res://Battle/resources/Combatants.tres")
@export var stats: EnemyStats

# Called when the node enters the scene tree for the first time.
func _ready():
	if not stats:
		stats = EnemyStats.new()
	stats = stats.duplicate()
	stats.setup()
	stats.health_changed.connect(_on_health_changed)
	stats.died.connect(_on_death)
	damage_label.text = "%s Damage" % stats.damage
	enemy_health_bar.max_value = stats.max_health
	enemy_health_bar.value = stats.health
	
func set_new_stats(new_stats: EnemyStats):
	stats = new_stats.duplicate()
	damage_label.text = "%s Damage" % stats.damage
	enemy_health_bar.max_value = stats.max_health
	enemy_health_bar.value = stats.health
	connect_to_stat_signals()
	
func connect_to_stat_signals():
	stats.health_changed.connect(_on_health_changed)
	stats.died.connect(_on_death)

func _on_health_changed(value):
	enemy_health_bar.value = value

func start_turn():
	act()
	emit_signal("turn_finished") 

func act():
	combatants.player.health -= stats.damage

func _on_death():
	emit_signal("died")
