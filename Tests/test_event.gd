extends Control

@onready var player = $Player

@export var event_data: EventData

# Called when the node enters the scene tree for the first time.
func _ready():
	var scene = event_data.instantiate_scene(RunData.player)
	add_child(scene)
