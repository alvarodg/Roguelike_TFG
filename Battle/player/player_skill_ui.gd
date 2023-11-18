extends Control

@onready var skill_grid = %SkillGrid
@onready var skill_box_scene = preload("res://Battle/coin_ui/skill_box.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(player: Player):
	for skill_data in player.skill_list:
		var skill_box = skill_box_scene.instantiate()
		skill_box.setup(skill_data)
		skill_grid.add_child(skill_box)

