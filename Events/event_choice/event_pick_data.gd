extends EventData
class_name EventPickData

const event_pick_scene = preload("res://Events/event_choice/event_pick.tscn")

@export_multiline var narrative: String
@export var image: Texture2D
@export var choices: Array[EventChoiceData]

func instantiate_scene(player: Player = null):
	var instance: EventPick = event_pick_scene.instantiate()
	instance.initialize(player, self)
	return instance
