extends Resource
class_name EventChoiceData

var scene: PackedScene = load("res://Events/event_choice/event_choice.tscn")

@export_multiline var description: String
@export var explicit: bool = true
@export var cost: Cost
@export var sequence: ChoiceSequence
@export var final: bool = true

func initialize_scene(player: Player):
	var scene_instance = scene.instantiate()
	scene_instance.initialize(player, self)
	return scene_instance
