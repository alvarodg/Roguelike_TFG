extends Resource
class_name EventChoiceData

const scene: PackedScene = preload("res://Events/event_choice/event_choice.tscn")

@export_multiline var description: String
@export var explicit: bool = true
@export var cost: Cost
@export var sequence: ChoiceSequence
@export var final: bool = true

func initialize_scene():
	var scene_instance = scene.instantiate()
	scene_instance.initialize(sequence, description, explicit, cost, final)
	return scene_instance
