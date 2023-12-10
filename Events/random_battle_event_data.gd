extends EventData
class_name RandomBattleEventData

@export var possible_enemies: Array[EnemyData]


func _init(p_scene = null, p_next_event = null, p_possible_enemies: Array[EnemyData] = []):
	super(p_scene, p_next_event)
	possible_enemies = p_possible_enemies

func instantiate_scene():
	var battle_scene = scene.instantiate()
	var enemy_data = pick_enemy()
	# Acceso al singleton de jugador
	battle_scene.setup(RunData.player, enemy_data, next_event)
	return battle_scene

func pick_enemy():
	# Acceso al singleton para el RNG global
	var chosen: int = RunData.rng.randi_range(0,possible_enemies.size()-1)
	return possible_enemies[chosen]
