extends EventData
class_name EventPickData

var event_pick_scene = load("res://Events/event_choice/event_pick_scene.tscn")

@export_multiline var narrative: String
@export var image: Texture2D
@export var choices: Array[EventChoiceData]

func instantiate_scene(player: Player):
	scene = event_pick_scene
	var instance: EventPick = super.instantiate_scene(player)
	instance.initialize(self)
	return instance
