extends EventData
class_name BattleEventData

@export var enemy_stats: EnemyStats
var battle_scene: PackedScene = preload("res://Battle/Battle.tscn")

#func _init(p_enemy_class):
#	super(battle_scene)
#	enemy_class = p_enemy_class

func instantiate_scene():
	var event_scene = battle_scene.instantiate()
	event_scene.enemy_stats = enemy_stats
	return event_scene
