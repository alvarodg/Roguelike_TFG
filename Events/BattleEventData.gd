extends EventData
class_name BattleEventData

@export var enemy_stats: EnemyStats

func _init(p_scene = null, p_next_event = null, p_enemy_stats = null):
	super(p_scene, p_next_event)
	enemy_stats = p_enemy_stats

func instantiate_scene():
	var battle_scene = scene.instantiate()
	battle_scene.setup_enemy(enemy_stats)
	battle_scene.next_event = next_event
	return battle_scene
