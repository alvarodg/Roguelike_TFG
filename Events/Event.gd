extends Resource
## Clase que representa un evento al que podrá acceder el jugador en el mapa
class_name Event

signal finished

## Icono del evento
@export var icon_normal: Texture2D
## Icono del evento cuando el foco del jugador está sobre este
@export var icon_hover: Texture2D
## Icono del evento cuando ya se ha completado
@export var icon_traveled: Texture2D
@export var text: String = ""
@export var id: int = 0
@export var event_data: EventData

## Instancia una escena del evento a partir del jugador
func instantiate_scene(player: Player):
	return event_data.instantiate_scene(player)

