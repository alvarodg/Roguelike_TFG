extends EventData
## Clase de datos para el evento de combate, guarda los datos de un enemigo
class_name BattleEventData

var battle_scene = load("res://Battle/CoinBattle.tscn")
## Datos del enemigo al que se enfrentará el jugador en este evento
@export var enemy_data: EnemyData

## Constructor
func _init(p_scene = null, p_next_event = null, p_enemy_data = null):
	super(p_scene, p_next_event)
	enemy_data = p_enemy_data

func instantiate_scene(player: Player):
	var battle_event = battle_scene.instantiate()
	battle_event.initialize(player, self)
	return battle_event

