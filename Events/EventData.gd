extends Resource
class_name EventData

@export var scene: PackedScene

func _init(p_scene: PackedScene = null):
	scene = p_scene

func instantiate_scene():
	return scene.instantiate()
