extends Resource
class_name GenerationData

@export var map_generator: MapGenerator
@export var event_assigner: EventAssigner
@export var map_bg: Texture2D
@export var default_battle_bg: Texture2D

func to_save_dict() -> Dictionary:
	return map_generator.to_save_dict().merge(event_assigner.to_save_dict())

func load_dict(dict: Dictionary):
	pass

func save_keys():
	return map_generator.SAVE_KEYS + event_assigner.SAVE_KEYS
