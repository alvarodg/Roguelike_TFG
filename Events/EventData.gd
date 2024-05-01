extends Resource
class_name EventData

enum Tag {DEFAULT, BATTLE, GAMBLE, TRADE, REWARD}

@export_multiline var description: String
@export var scene: PackedScene
@export var next_event: EventData
@export var rarity: int = 1
@export var tags: Array[Tag] = [Tag.DEFAULT]
@export var secret: bool = false
@export var goes_to_next_level: bool = false
@export var is_final_event: bool = false

func _init(p_scene: PackedScene = null, p_next_event: EventData = null, p_rarity = 1):
	scene = p_scene
	next_event = p_next_event
	rarity = p_rarity

func instantiate_scene(player: Player):
	var scene_instance: EventScene = scene.instantiate()
	scene_instance.initialize(player, self)
#	scene_instance.goes_to_next_level = goes_to_next_level
#	assert(scene_instance is EventScene)
#	scene_instance.next_event = next_event
	return scene_instance

func get_description():
	if description == "":
		return "Default Event"
	else:
		return description
