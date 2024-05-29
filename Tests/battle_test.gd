extends Control

@onready var battle_scene: PackedScene = preload("res://Battle/CoinBattle.tscn")
@onready var player = $Player
@export var enemy_data: EnemyData

# Called when the node enters the scene tree for the first time.
func _ready():
	var battle_data = BattleEventData.new()
	battle_data.enemy_data = enemy_data
	var battle = battle_data.instantiate_scene(player)
	add_child(battle)
