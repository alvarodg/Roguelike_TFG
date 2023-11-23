extends Resource
class_name PlayerUIData

@export var icon: Texture2D
@export var ui_name: String

func to_save_dict() -> Dictionary:
	return {
		"icon" : icon.resource_path,
		"ui_name" : ui_name
	}

func load_dict(dict: Dictionary):
	icon = load(dict["icon"])
	ui_name = dict["ui_name"]

static func save_keys():
	return ["icon", "ui_name"]
