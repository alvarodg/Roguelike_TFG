extends EventData
## Clase de datos para el evento de combate, guarda los datos de un enemigo
class_name BattleEventData

var battle_scene = load("res://Battle/CoinBattle.tscn")
## Datos del enemigo al que se enfrentará el jugador en este evento
@export var enemy_data: EnemyData

## Constructor
func _init(p_next_event = null, p_enemy_data = null):
	super(p_next_event)
	enemy_data = p_enemy_data

func instantiate_scene(player: Player):
	return _inner_instantiate(player, battle_scene)

