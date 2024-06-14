extends EventScene
class_name SkillChoice

@onready var choice_container = %ChoiceContainer
@onready var pick_skill_ui_scene = preload("res://Events/pick_skill_ui.tscn")
@onready var remove_skill_choice_scene = preload("res://Events/remove_skill_choice.tscn")
var choices: int
var skill_collection: SkillCollection
var skill_tags: Array[SkillData.Tag]
var tag_op: Collection.Operator
var rarities: Array[int]
var rarity_factor: float
var deterministic: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var skill_list: Array[SkillData] = []
	var rng = RunData.rng if deterministic else RandomNumberGenerator.new()
	if skill_collection == null or skill_collection.size() == 0:
		skill_list.assign(RunData.collections.get_random_skill_list(choices, skill_tags, tag_op, rarities, rarity_factor))
	else:
		skill_list.assign(skill_collection.get_random_list(choices, rng, skill_tags, tag_op, rarities, rarity_factor))
	for skill in skill_list:
		var pick_skill_ui = pick_skill_ui_scene.instantiate()
		pick_skill_ui.setup(player, skill)
		pick_skill_ui.skill_chosen.connect(_on_Skill_chosen)
		choice_container.add_child(pick_skill_ui)
		

func initialize(p_player: Player, data: SkillChoiceData):
	super.initialize(p_player, data)
	choices = data.choices
	skill_collection = data.skill_collection
	skill_tags = data.skill_tags
	tag_op = data.tag_op
	rarities = data.rarities
	rarity_factor = data.rarity_factor
	deterministic = data.deterministic


func _on_Skill_chosen(skill):
	if player.skill_list.size() == player.max_skills:
		var remove_skill_choice = remove_skill_choice_scene.instantiate()
		remove_skill_choice.setup(player)
		get_parent().add_child(remove_skill_choice)
		hide()
		var chosen_skill = await remove_skill_choice.skill_chosen
		if chosen_skill != null:
			player.remove_skill(chosen_skill)
			RunData.collections.add(chosen_skill)
			player.add_skill(skill)
			RunData.collections.remove(skill)
		finish()
	else:
		player.add_skill(skill)
		RunData.collections.remove(skill)
		finish()

func _on_SkipButton_pressed():
	finish()


