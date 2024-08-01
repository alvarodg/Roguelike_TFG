extends EventData
class_name SkillChoiceData

@export var choices: int = 3
@export var skill_collection: SkillCollection
@export var skill_tags: Array[SkillData.Tag]
@export var tag_op: Collection.Operator = Collection.Operator.OR
@export var rarities: Array[int]
@export var rarity_factor: float = 1.0
@export var deterministic: bool = true

var skill_choice_scene = load("res://Events/skill_choice.tscn")

func instantiate_scene(player: Player):
	#scene = load("res://Events/skill_choice.tscn")
	#var instance: SkillChoice = scene.instantiate()
	#var instance: SkillChoice = _inner_instantiate(player, skill_choice_scene)
	#instance.initialize(player, self)
	return _inner_instantiate(player, skill_choice_scene)
