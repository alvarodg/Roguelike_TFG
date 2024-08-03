extends Resource
class_name EventData

## Etiquetas descriptivas para filtrar eventos
enum Tag {DEFAULT, BATTLE, GAMBLE, TRADE, REWARD}

## Nombre del evento
@export var name: String
## Descripción del evento
@export_multiline var description: String
## Siguiente evento, que se iniciará en cuanto termine
@export var next_event: EventData
## A mayor rarity, menos común que el evento aparezca aleatoriamente
@export var rarity: int = 1
## Tags para filtrar el evento
@export var tags: Array[Tag] = [Tag.DEFAULT]
@export var secret: bool = false
## Un evento único se elimina de la lista de eventos disponibles cuando termina
@export var unique: bool = false
## Indica si pasará o no al siguiente nivel al terminar
@export var goes_to_next_level: bool = false
## Indica si finalizará la partida o no al terminar
@export var is_final_event: bool = false
## Eventos que se añadirán a la lista de eventos disponibles cuando termine
@export var event_unlocks: Array[EventData] = []

var default = load("res://Events/resources/event_data/empty/empty_event.tres")

## Constructor	
func _init(p_next_event: EventData = null, p_rarity = 1):
	next_event = p_next_event
	rarity = p_rarity

## Devuelve una instancia de la escena del evento para el jugador
func instantiate_scene(player: Player) -> EventScene:
	return _inner_instantiate(player, default)

func _inner_instantiate(player: Player, p_scene) -> EventScene:
	var scene_instance: EventScene = p_scene.instantiate()
	scene_instance.initialize(player, self)
	return scene_instance


func get_description() -> String:
	return description
