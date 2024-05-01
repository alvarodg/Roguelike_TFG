extends Resource
class_name EventChoiceData

var scene: PackedScene = load("res://Events/event_choice/event_choice.tscn")

@export_multiline var description: String
@export var explicit: bool = false
@export var cost: Cost
@export var sequence: ChoiceSequence
@export var final: bool = true
@export var secret: bool = false

func create_instance(player: Player):
	var instance = scene.instantiate()
	instance.initialize(player, self)
	return instance
