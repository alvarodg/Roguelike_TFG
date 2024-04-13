extends Resource

const scene: PackedScene = preload("res://Events/event_choice/event_choice.tscn")

@export var pre_modifiers: Array[Modifier]
@export var post_modifiers: Array[Modifier]
@export var events: Array[EventData]

func initialize_scene():
	var scene_instance = scene.instantiate()
	scene_instance.initialize(events, pre_modifiers, post_modifiers)
