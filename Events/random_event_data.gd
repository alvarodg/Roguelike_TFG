extends EventData
class_name RandomEventData

var random_scene = load("res://Events/random_event.tscn")

@export var events: EventCollection
@export var event_tags: Array[EventData.Tag]
@export var tag_op: Collection.Operator = Collection.Operator.OR
@export var rarities: Array[int]
@export var deterministic: bool = true
@export var default_event: EventData = load("res://Events/resources/event_data/empty/empty_event.tres")

func instantiate_scene(player: Player):
	scene = random_scene
	var instance: RandomEvent = super.instantiate_scene(player)
	instance.setup(self)
	return instance
