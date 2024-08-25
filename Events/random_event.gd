extends EventScene
class_name RandomEvent

var events: EventCollection
var event_tags: Array[EventData.Tag]
var tag_op: EventCollection.Operator
var rarities: Array[int]
var deterministic: bool
var default_event: EventData

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	#if default_event == null: default_event = load("res://Events/resources/event_data/empty/empty_event.tres")
	print(RunData.collections.events)
	## Si no se le pasa una colección de eventos, accede al Singleton RunData
	## para recibir la lista de eventos general
	if events == null:
		events = RunData.collections.events
	## Usa el rng de RunData si se pide un resultado determinista
	var rng = RunData.rng if deterministic else RandomNumberGenerator.new()
	var event = events.get_random(rng, event_tags, tag_op, rarities)
	if event == null: 
		event = default_event
	var scene = event.instantiate_scene(player)
	scene.finished.connect(finish)
	add_child(scene)


func initialize(p_player: Player, data: RandomEventData):
	super.initialize(p_player, data)
	default_event = data.default_event
	events = data.events
	# CAMBIO
	event_tags = data.event_tags
	tag_op = data.tag_op
	rarities = data.rarities
	deterministic = data.deterministic
