extends Control

signal finished

@onready var choice_container = %ChoiceContainer
@onready var pick_skill_ui_scene = preload("res://Events/pick_skill_ui.tscn")
@onready var remove_skill_choice_scene = preload("res://Events/remove_skill_choice.tscn")
@export var choices: int = 3
@export var skill_list: Array[SkillData]
var next_event: EventData

# Called when the node enters the scene tree for the first time.
func _ready():
	if skill_list.size() == 0:
		skill_list = RunData.collections.get_random_skill_list(choices)
	for skill in skill_list:
		var pick_skill_ui = pick_skill_ui_scene.instantiate()
		pick_skill_ui.setup(skill)
		pick_skill_ui.skill_chosen.connect(_on_Skill_chosen)
		choice_container.add_child(pick_skill_ui)
		

func setup(p_choices = 3, fixed_skill_list: Array[SkillData] = []):
	choices = p_choices
	skill_list = fixed_skill_list


func finish():
	if next_event is EventData:
		var next_scene = next_event.instantiate_scene()
		get_parent().add_child(next_scene) 
		hide()
		await next_scene.finished
	finished.emit()
	queue_free()


func _on_Skill_chosen(skill):
	# ¿Pasar por parámetro en lugar de singleton?
	var player: Player = RunData.player
	if player.skill_list.size() == player.max_skills:
		var remove_skill_choice = remove_skill_choice_scene.instantiate()
		remove_skill_choice.setup(player.skill_list)
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


