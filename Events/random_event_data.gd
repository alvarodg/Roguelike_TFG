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
	var instance: RandomEvent = _inner_instantiate(player, random_scene)
	return instance

#
#func pick_event(player: Player):
	#if default_event == null: default_event = load("res://Events/resources/event_data/empty/empty_event.tres")
	### Si no se le pasa una colección de eventos, accede al Singleton RunData
	### para recibir la lista de eventos general
	#if events == null:
		#events = RunData.collections.events
	### Usa el rng de RunData si se pide un resultado determinista
	#var rng = RunData.rng if deterministic else RandomNumberGenerator.new()
	#var event = events.get_random(rng, tags, tag_op, rarities)
	#if event == null: 
		#event = default_event
	#return event
	##var scene = event.instantiate_scene(player)
