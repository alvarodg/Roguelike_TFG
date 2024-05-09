extends Collection
class_name EventCollection

@export var list: Array[EventData]

func _init(p_list: Array[EventData] = []):
	list = p_list
	print(list)

func add(element: EventData):
	list.append(element)

func remove(element: EventData):
	list.erase(element)

func size() -> int:
	return list.size()

func get_random(rng: RandomNumberGenerator = RandomNumberGenerator.new(), tags: Array[EventData.Tag] = [], op: Operator = Operator.OR, rarity_pick: Array[int] = [], rarity_factor: float = 1) -> EventData:
	return _get_random_from_list(list, rng, tags, op, rarity_pick, rarity_factor)
	
#func _choose_random_index_from(rarity_list: Array, rng: RandomNumberGenerator = RandomNumberGenerator.new(), rarity_factor: float = 1):
#	var chosen: int = 0
#	var total_chance = 0.0
#	for rarity in rarity_list:
#		total_chance += 1.0/(1 + rarity * rarity_factor)
#	var current_chance = 0.0
#	var roll = rng.randf_range(0,total_chance)
#	for i in range(rarity_list.size()):
#		current_chance += 1.0/(1 + rarity_list[i] * rarity_factor)
#		if current_chance >= roll:
#			chosen = i
#			break
#	return chosen
