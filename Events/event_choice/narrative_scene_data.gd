extends Resource
class_name NarrativeSceneData

var scene: PackedScene = load("res://Events/event_choice/narrative_scene.tscn")

@export_multiline var narrative: Array[String]
@export var image: Texture2D

func instantiate_scene(player: Player):
	var instance: NarrativeScene = scene.instantiate()
	instance.initialize(player, narrative, image)
	return instance
