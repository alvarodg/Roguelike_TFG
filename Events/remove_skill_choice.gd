extends Control

signal finished
signal skill_chosen(skill)

@onready var choice_container = %ChoiceContainer
@onready var pick_skill_ui_scene = preload("res://Events/pick_skill_ui.tscn")
@export var skill_list: Array[SkillData]
var next_event: EventData
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	for skill in skill_list:
		var pick_skill_ui = pick_skill_ui_scene.instantiate()
		pick_skill_ui.setup(player, skill)
		pick_skill_ui.skill_chosen.connect(_on_Skill_chosen)
		choice_container.add_child(pick_skill_ui)
		

func setup(p_player: Player):
	skill_list = p_player.skill_list

func _on_Skill_chosen(skill):
	skill_chosen.emit(skill)
	queue_free()
	
func _on_SkipButton_pressed():
	skill_chosen.emit(null)
	queue_free()

