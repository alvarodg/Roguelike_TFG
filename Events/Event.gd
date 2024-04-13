extends Resource
class_name Event

signal finished

@export var icon_normal: Texture2D
@export var icon_hover: Texture2D
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
	
func instantiate_scene():
	return event_data.instantiate_scene()

#func get_description():
#	return "Default Event"
