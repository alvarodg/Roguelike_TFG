extends EventData
class_name NarrativeEventData

@export_multiline var narrative: Array[String]
@export var image: Texture2D

var narrative_scene = load("res://Events/narrative_event.tscn")

func instantiate_scene(player: Player):
	return _inner_instantiate(player,narrative_scene)
