extends Collection
class_name EquipmentCollection

@export var list: Array[Equipment]

func _init(p_list: Array[Equipment] = []):
	list = p_list

func add(element: Equipment):
	list.append(element)

func remove(element: Equipment):
	list.erase(element)

func size() -> int:
	return list.size()

func get_random(tags: Array[Equipment.Tag] = [], op: Operator = Operator.OR, rarity_pick: Array[int] = [], rarity_factor: float = 1) -> Equipment:
	var pickable: Array[Equipment] = list
	if tags.size() > 0:
		if op == Operator.OR:
			pickable = pickable.filter(
				func(x: Equipment): return x.tags.any(
					func(x: Equipment.Tag): return tags.has(x)))
		else:
			pickable = pickable.filter(
				func(x: Equipment): return x.tags.all(
					func(x: Equipment.Tag): return tags.has(x)))
	if rarity_pick.size() > 0:
		pickable = list.filter(func(x: Equipment): return rarity_pick.has(x.rarity))
	var rarity_list: Array[int] = []
	for item in pickable:
		rarity_list.append(item.rarity)
	var chosen: int = _choose_random_index_from(rarity_list, rarity_factor)
	return pickable[chosen]
