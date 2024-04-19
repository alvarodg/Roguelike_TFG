extends Resource
class_name EventCollection

@export var list: Array[EventData]

func _init(p_list: Array[EventData] = []):
	list = p_list

func get_random(rarity_factor = 1) -> EventData:
	var chosen: EventData
	var total_chance = 0.0
	for event in list:
		total_chance += 1.0/(1 + event.rarity * rarity_factor)
	var current_chance = 0.0
	var roll = randf_range(0,total_chance)
	for i in range(list.size()):
		current_chance += 1.0/(1 + list[i].rarity * rarity_factor)
		if current_chance >= roll:
			chosen = list[i]
			break
	return chosen
