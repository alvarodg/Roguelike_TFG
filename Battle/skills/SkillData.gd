extends Resource
class_name SkillData

@export var ui_data: SkillUIData
@export var name: String
@export var cost: Array[int] : set = set_cost
@export var uses_per_turn: int = 1
@export var one_shot: bool = false
@export var cost_is_mandatory: bool = true
@export var rarity: int = 0
@export var behaviors: Array[SkillBehavior]
const COST_TYPES = 3

func set_cost(value):
	cost = value
	if cost.size() > COST_TYPES:
		cost.resize(COST_TYPES)

func get_description() -> String:
	var description: String = ""
	for behavior in behaviors:
		if description != "": description += "\n"
		description += behavior.get_description()
	return description

func create_skill(user, target, coins = []) -> Skill:
	return Skill.new(self, user, target, coins)
