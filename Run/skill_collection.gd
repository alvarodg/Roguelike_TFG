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

#func get_random(tags: Array[SkillData.Tag] = [], op: Operator = Operator.OR, rarity_pick: Array[int] = [], rarity_factor: float = 1) -> SkillData:
##	var chosen: EventData
#	var pickable: Array[SkillData] = list
#	if tags.size() > 0:
#		if op == Operator.OR:
#			pickable = pickable.filter(
#				func(x: SkillData): return x.tags.any(
#					func(x: SkillData.Tag): return tags.has(x)))
#		else:
#			pickable = pickable.filter(
#				func(x: SkillData): return x.tags.all(
#					func(x: SkillData.Tag): return tags.has(x)))
#	if rarity_pick.size() > 0:
#		pickable = list.filter(func(x: SkillData): return rarity_pick.has(x.rarity))
#	var rarity_list: Array[int] = []
#	for item in pickable:
#		rarity_list.append(item.rarity)
#	var chosen: int = _choose_random_index_from(rarity_list)
#	return pickable[chosen] if pickable.size() > 0 else null

func get_random(tags: Array[SkillData.Tag] = [], op: Operator = Operator.OR, rarity_pick: Array[int] = [], rarity_factor: float = 1) -> SkillData:
	return _get_random_from_list(list, tags, op, rarity_pick, rarity_factor)
