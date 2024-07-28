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

func get_random(rng: RandomNumberGenerator = RandomNumberGenerator.new(), 
				tags: Array[Equipment.Tag] = [], op: Operator = Operator.OR, 
				rarity_pick: Array[int] = [], rarity_factor: float = 1):
	return _get_random_from_list(list, rng, tags, op, rarity_pick, rarity_factor)
