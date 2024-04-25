extends Resource
class_name EventCollection

@export var list: Array[EventData]

enum Operator {AND, OR}

func _init(p_list: Array[EventData] = []):
	list = p_list

func get_random(tags: Array[EventData.Tag] = [], op: Operator = Operator.OR, rarity_pick: Array[int] = [], rarity_factor: float = 1) -> EventData:
	var chosen: EventData
	var pickable: Array[EventData] = list
	if tags.size() > 0:
		if op == Operator.OR:
			pickable = pickable.filter(
				func(x: EventData): return x.tags.any(
					func(x: EventData.Tag): return tags.has(x)))
		else:
			pickable = pickable.filter(
				func(x: EventData): return x.tags.all(
					func(x: EventData.Tag): return tags.has(x)))
	if rarity_pick.size() > 0:
		pickable = list.filter(func(x: EventData): return rarity_pick.has(x.rarity))
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
