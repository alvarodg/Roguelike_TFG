extends Resource
class_name EventData

@export_multiline var description: String
@export var scene: PackedScene
@export var next_event: EventData

func _init(p_scene: PackedScene = null, p_next_event: EventData = null):
	scene = p_scene
	next_event = p_next_event

func instantiate_scene():
	var scene_instance = scene.instantiate()
	assert(scene_instance is EventScene)
	scene_instance.next_event = next_event
	return scene_instance

func get_description():
	if description == "":
		return "Default Event"
	else:
		return description
