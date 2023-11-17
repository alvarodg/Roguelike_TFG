extends Resource
class_name SkillData

@export var icon: Texture2D
@export var name: String
@export var cost: Array[int] : set = set_cost
@export var uses_per_turn: int = 1
@export var one_shot: bool = false
const COST_TYPES = 3


func set_cost(value):
	cost = value
	if cost.size() > COST_TYPES:
		cost.resize(COST_TYPES)

func get_description() -> String:
	return "This skill has no effect."

# Patrón Factory Method
func create_skill(user, target) -> Skill:
	return Skill.new(self, user, target)
