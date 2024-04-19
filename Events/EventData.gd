extends Resource
class_name EventData

@export_multiline var description: String
@export var scene: PackedScene
@export var next_event: EventData
@export var rarity: int = 1

func _init(p_scene: PackedScene = null, p_next_event: EventData = null, p_rarity = 1):
	scene = p_scene
	next_event = p_next_event
	rarity = p_rarity

func instantiate_scene(player: Player):
	var scene_instance: EventScene = scene.instantiate()
	scene_instance.player = player
	assert(scene_instance is EventScene)
	scene_instance.next_event = next_event
	return scene_instance

func get_description():
	if description == "":
		return "Default Event"
	else:
		return description
