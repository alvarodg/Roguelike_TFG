extends CombatantUIData
class_name PlayerUIData

func to_save_dict() -> Dictionary:
	return {
		"sprite" : sprite.resource_path,
		"ui_name" : ui_name
	}

func load_dict(dict: Dictionary):
	sprite = load(dict["sprite"])
	ui_name = dict["ui_name"]

static func save_keys():
	return ["sprite", "ui_name"]
