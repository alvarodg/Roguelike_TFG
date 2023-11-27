extends Resource
class_name Equipment

@export var ui_data: EquipmentUIData = EquipmentUIData.new()
@export var description: String = ""
@export var modifiers: Array[Modifier]

# Called when the node enters the scene tree for the first time.
func attach_to(user):
	for mod in modifiers:
		mod.apply_to(user)

func get_description() -> String:
	if description == "":
		var desc = ""
		for mod in modifiers:
			if desc != "": desc += "\n"
			desc += mod.get_description()
		return desc
	else: 
		return description
