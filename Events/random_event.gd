extends EventScene
class_name RandomEvent

var events: EventCollection
var tags: Array[EventData.Tag]
var tag_op: EventCollection.Operator
var rarities: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready():
#	var events = RunData.collections.events
	var event = events.get_random(tags, tag_op, rarities).instantiate_scene(player)
	event.finished.connect(finish)
	add_child(event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup(data: RandomEventData):
	events = data.events
	tags = data.event_tags
	tag_op = data.tag_op
	rarities = data.rarities
