extends EventChoiceData
class_name SplitEventChoiceData

@export var alt_sequence: ChoiceSequence = ChoiceSequence.new()
@export var coinbox_data: ChoiceCoinBoxData = ChoiceCoinBoxData.new()
@export var deterministic: bool = true

var split_scene: PackedScene = load("res://Events/event_choice/split_event_choice.tscn")

func create_instance(player: Player):
	var instance: SplitEventChoice = split_scene.instantiate()
	instance.initialize(player, self)
	return instance
