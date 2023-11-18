extends Control

signal finished

@onready var choice_container = %ChoiceContainer
@onready var add_skill_ui_scene = preload("res://Events/add_skill_ui.tscn")
@export var choices: int = 3
@export var skill_list: Array[SkillData]
var next_event: EventData

# Called when the node enters the scene tree for the first time.
func _ready():
	if skill_list.size() == 0:
#		skill_list = RunData.equipment_node.get_random_equipment_list(choices)
		pass
	for skill in skill_list:
		var add_skill_ui = add_skill_ui_scene.instantiate()
		add_skill_ui.setup(RunData.player, skill)
		add_skill_ui.skill_chosen.connect(_on_Skill_chosen)
		choice_container.add_child(add_skill_ui)
		

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


func _on_Skill_chosen(_skill):
	finish()

func _on_SkipButton_pressed():
	finish()


