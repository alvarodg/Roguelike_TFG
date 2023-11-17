extends Node
class_name EquipmentNode

@export var collection: EquipmentCollection

# Called when the node enters the scene tree for the first time.
func _ready():
	RunData.equipment_node = self

# Saca un equipamiento de equip_list, modifica la lista.
func _get_random_equipment(equip_list: Array[Equipment], rarity: int = -1):
	var pickable_list: Array[Equipment] = []
	if rarity > 0:
		for equipment in equip_list:
			if equipment.rarity == rarity:
				pickable_list.append(equipment)
		var chosen = pickable_list.pick_random()
		equip_list.erase(chosen)
		return chosen
	else:
		#TEMPORAL
		var chosen = equip_list.pick_random()
		equip_list.erase(chosen)
		return chosen

func get_random_equipment_list(size: int = 1, rarity: int = -1) -> Array[Equipment]:
	var list: Array[Equipment] = collection.equipment_list.duplicate()
	var chosen_list: Array[Equipment] = []
	for i in range(size):
		chosen_list.append(_get_random_equipment(list, rarity))
	return chosen_list



func remove_equipment(equipment: Equipment):
	collection.equipment_list.erase(equipment)
