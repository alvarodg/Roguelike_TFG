extends Resource
class_name EventData

## Tags descriptivas para filtrar eventos
enum Tag {DEFAULT, BATTLE, GAMBLE, TRADE, REWARD}

## Nombre del evento
@export var name: String
## Descripción del evento
@export_multiline var description: String
## Escena del evento (se usa para genéricos, a sobreescribir en subclases)
@export var scene: PackedScene
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

## Constructor	
func _init(p_scene: PackedScene = null, p_next_event: EventData = null, p_rarity = 1):
	scene = p_scene
	next_event = p_next_event
	rarity = p_rarity

## Devuelve una escena
func instantiate_scene(player: Player):
	var scene_instance: EventScene = scene.instantiate()
	scene_instance.initialize(player, self)
#	scene_instance.goes_to_next_level = goes_to_next_level
#	assert(scene_instance is EventScene)
#	scene_instance.next_event = next_event
	return scene_instance

func get_description():
	if description == "":
		return "Default Event"
	else:
		return description
