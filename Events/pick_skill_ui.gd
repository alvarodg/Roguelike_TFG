extends Control

signal skill_chosen(skill)

@export var skill: SkillData
@onready var skill_v_box_container = %SkillVBoxContainer
@onready var skill_box_scene: PackedScene = preload("res://Battle/coin_ui/skill_box.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var skill_box: SkillBox = skill_box_scene.instantiate()
#	skill_box.mouse_filter = MOUSE_FILTER_IGNORE
	skill_box.setup(skill)
	skill_v_box_container.add_child(skill_box)
	skill_box.remove_buttons()
	skill_v_box_container.move_child(skill_box, 0)
	
func setup(p_skill: SkillData):
	skill = p_skill


func _on_PickButton_pressed():
	skill_chosen.emit(skill)
