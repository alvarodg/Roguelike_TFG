extends EventData
class_name BattleEventData

@export var enemy_stats: EnemyStats

func _init(p_scene = null, p_enemy_stats = null):
	super(p_scene)
	enemy_stats = p_enemy_stats

func instantiate_scene():
	var battle_scene = scene.instantiate()
	battle_scene.setup_enemy(enemy_stats)
	return battle_scene
