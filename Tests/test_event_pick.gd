extends Control

@onready var player = $Player

@export var event_pick_data: EventPickData

# Called when the node enters the scene tree for the first time.
func _ready():
	var scene = event_pick_data.instantiate_scene(player)
	add_child(scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
