extends Control

@onready var battle_scene: PackedScene = preload("res://Battle/CoinBattle.tscn")
@onready var player = $Player
@export var enemy_data: EnemyData

# Called when the node enters the scene tree for the first time.
func _ready():
	var battle = battle_scene.instantiate()
	battle.setup(player,enemy_data)
	add_child(battle)
