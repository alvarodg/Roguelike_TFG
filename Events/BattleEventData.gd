extends EventData
class_name BattleEventData

@export var enemy_data: EnemyData

func _init(p_scene = null, p_next_event = null, p_enemy_data = null):
	super(p_scene, p_next_event)
	enemy_data = p_enemy_data

func instantiate_scene():
	var battle_scene = scene.instantiate()
	# Acceso al singleton de jugador
	battle_scene.setup(RunData.player, enemy_data, next_event)
	return battle_scene
