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
#
#func _init(p_icon_normal = null, p_icon_hover = null, p_icon_traveled = null, p_text = "", p_event_data = null):
#	icon_normal = p_icon_normal
#	icon_hover = p_icon_hover
#	icon_traveled = p_icon_traveled
#	text = p_text
#	event_data = p_event_data
	
## Instancia una escena del evento a partir del jugador
func instantiate_scene(player: Player):
	return event_data.instantiate_scene(player)

#func get_description():
#	return "Default Event"
