extends Resource
class_name Collection

enum Operator {AND, OR}

func add(element):
	pass

func remove(element):
	pass

func size() -> int:
	return 0

func get_random(tags: Array = [], op: Operator = Operator.OR, rarity_pick: Array[int] = [], rarity_factor: float = 1):
	return null

func get_random_list(amount: int = 1, tags: Array = [],
 op: Collection.Operator = Collection.Operator.OR, rarity_pick: Array[int] = [], 
 rarity_factor: float = 1) -> Array:
	# Duplica la colección para poder sacar elementos temporalmente.
	var collection: Collection = self.duplicate()
	var picks: int = min(amount, collection.size())
	var chosen_list: Array = []
	for i in range(picks):
		var chosen_skill = collection.pick_random(tags, op, rarity_pick, rarity_factor)
		if chosen_skill != null:
			chosen_list.append(chosen_skill)
			collection.remove(chosen_skill)
	return chosen_list

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

func _get_random_from_list(list: Array[Variant], tags: Array[Variant] = [], op: Operator = Operator.OR, rarity_pick: Array[int] = [], rarity_factor: float = 1) -> Variant:
	var pickable: Array[Equipment] = list
	# Comprueba que la clase de los objetos de la lista tiene una variable "tags"
	if not "tags" in list.front() or not "rarity" in list.front():
		return null
	if tags.size() > 0:
		if op == Operator.OR:
			pickable = pickable.filter(
				func(x): return x.tags.any(
					func(x): return tags.has(x)))
		if op == Operator.AND:
			pickable = pickable.filter(
				func(x): return x.tags.all(
					func(x): return tags.has(x)))
	if rarity_pick.size() > 0:
		pickable = list.filter(func(x): return rarity_pick.has(x.rarity))
	var rarity_list: Array[int] = []
	for item in pickable:
		rarity_list.append(item.rarity)
	var chosen: int = _choose_random_index_from(rarity_list, rarity_factor)
	return pickable[chosen]
