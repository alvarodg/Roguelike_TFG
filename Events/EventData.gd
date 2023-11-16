extends Resource
class_name EventData

@export var scene: PackedScene
@export var next_event: EventData

func _init(p_scene: PackedScene = null, p_next_event: EventData = null):
	scene = p_scene
	next_event = p_next_event

func instantiate_scene():
	var scene_instance = scene.instantiate()
	scene_instance.next_event = next_event
	return scene_instance
