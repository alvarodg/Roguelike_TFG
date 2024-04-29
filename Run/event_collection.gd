extends Collection
class_name EventCollection

@export var list: Array[EventData]

func _init(p_list: Array[EventData] = []):
	list = p_list

func add(element: EventData):
	list.append(element)

func remove(element: EventData):
	list.erase(element)

func size() -> int:
	return list.size()

func get_random(tags: Array[EventData.Tag] = [], op: Operator = Operator.OR, rarity_pick: Array[int] = [], rarity_factor: float = 1) -> EventData:
#	var chosen: EventData
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
	var rarity_list: Array[int] = []
	for item in pickable:
		rarity_list.append(item.rarity)
	var chosen: int = _choose_random_index_from(rarity_list, rarity_factor)
	return pickable[chosen]
#	var total_chance = 0.0
#	for event in pickable:
#		total_chance += 1.0/(1 + event.rarity * rarity_factor)
#	var current_chance = 0.0
#	var roll = randf_range(0,total_chance)
#	for i in range(list.size()):
#		current_chance += 1.0/(1 + list[i].rarity * rarity_factor)
#		if current_chance >= roll:
#			chosen = list[i]
#			break
#	return chosen

func _choose_random_index_from(rarity_list: Array, rarity_factor: float = 1):
	var chosen: int = 0
	var total_chance = 0.0
	for rarity in rarity_list:
		total_chance += 1.0/(1 + rarity * rarity_factor)
	var current_chance = 0.0
	var roll = randf_range(0,total_chance)
	for i in range(rarity_list.size()):
		current_chance += 1.0/(1 + rarity_list[i] * rarity_factor)
		if current_chance >= roll:
			chosen = i
			break
	return chosen
