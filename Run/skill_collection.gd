extends Collection
class_name SkillCollection

@export var list: Array[SkillData]

func _init(p_list: Array[SkillData] = []):
	list = p_list

func add(element: SkillData):
	list.append(element)

func remove(element: SkillData):
	list.erase(element)

func size() -> int:
	return list.size()

func get_random(rng: RandomNumberGenerator = RandomNumberGenerator.new(),
				tags: Array[SkillData.Tag] = [], op: Operator = Operator.OR, 
				rarity_pick: Array[int] = [], rarity_factor: float = 1) -> SkillData:
	return _get_random_from_list(list, rng, tags, op, rarity_pick, rarity_factor)
