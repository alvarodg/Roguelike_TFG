extends EventData
class_name RandomEventData

const random_scene = preload("res://Events/random_event.tscn")

@export var events: EventCollection

func instantiate_scene(player: Player):
	var instance: RandomEvent = super.instantiate_scene(player)
	instance.setup(events)
	return instance
