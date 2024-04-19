extends EventData
class_name BattleEventData

var battle_scene = load("res://Battle/CoinBattle.tscn")
@export var enemy_data: EnemyData

func _init(p_scene = null, p_next_event = null, p_enemy_data = null):
	super(p_scene, p_next_event)
	enemy_data = p_enemy_data

func instantiate_scene(player: Player = null):
	var battle_event = battle_scene.instantiate()
	battle_event.setup(player, enemy_data, next_event)
	return battle_event

