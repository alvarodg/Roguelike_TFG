extends EventScene
class_name RandomEvent

@export var events: EventCollection

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(events.get_random().instantiate_scene(player))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup(event_collection: EventCollection):
	events = event_collection
