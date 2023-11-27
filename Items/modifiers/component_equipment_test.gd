extends Equipment
class_name ComponentEquipment

@export var modifiers: Array[ModifierComponent]

# Called when the node enters the scene tree for the first time.
func attach_to(user):
	for mod in modifiers:
		mod.apply_to(user)

