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
@export var modifiers: Array[Modifier]
@export var modifiers_first: bool = true
const COST_TYPES = 3

func set_cost(value):
	cost = value
	if cost.size() > COST_TYPES:
		cost.resize(COST_TYPES)

func get_description(combatant: Combatant = null) -> String:
	var description: String = ""
	var modifier_description: String = ""
	var behavior_description: String = ""
	for modifier in modifiers:
		if modifier_description != "": modifier_description += "\n"
		modifier_description += modifier.get_description(combatant)
	for behavior in behaviors:
		if behavior_description != "": behavior_description += "\n"
		behavior_description += behavior.get_description(combatant)
	if modifiers_first:
		description = modifier_description + "\n" + behavior_description
	else:
		description = behavior_description + "\n" + modifier_description
	return description.strip_edges()

func create_skill(user, target, coins = []) -> Skill:
	return Skill.new(self, user, target, coins)
