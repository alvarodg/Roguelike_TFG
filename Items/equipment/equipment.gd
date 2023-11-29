extends Resource
class_name Equipment

@export var ui_data: EquipmentUIData = EquipmentUIData.new()
@export var description: String = ""
@export var modifiers: Array[Modifier]
# Probablemente crear un padre común a modifier y trigger
@export var triggers: Array[Trigger]

# Called when the node enters the scene tree for the first time.
func attach_to(user):
	for mod in modifiers:
		mod.apply_to(user)
	for trigger in triggers:
		trigger.apply_to(user)
	
func setup():
	for trigger in triggers:
		trigger.setup()
	
func get_description() -> String:
	if description == "":
		var desc = ""
		for mod in modifiers:
			if desc != "": desc += "\n"
			desc += mod.get_description()
		for trigger in triggers:
			if desc != "": desc += "\n"
			desc += trigger.get_description()
		return desc
	else: 
		return description
