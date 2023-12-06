extends Control

@export var skill_amount: int = 4

@onready var skill_icon_scene = preload("res://Battle/enemy/skills/enemy_skill_icon.tscn")
@onready var icon_h_box = %IconHBox

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(enemy: Enemy):
	enemy.upcoming_skills_changed.connect(_on_Enemy_upcoming_changed)
	create_icons(enemy.upcoming_skills)
	
func create_icons(skill_list: Array[EnemySkillData]):
	for i in range(min(skill_list.size(),skill_amount)):
		var icon = skill_icon_scene.instantiate()
		icon.setup(skill_list[i])
		icon_h_box.add_child(icon)
		icon.state = EnemySkillIcon.State.INACTIVE
		if i == 0: icon.state = EnemySkillIcon.State.ACTIVE
	
func clear_icons():
	for icon in icon_h_box.get_children():
		if icon is EnemySkillIcon: icon.queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_Enemy_upcoming_changed(value: Array[EnemySkillData]):
	clear_icons()
	create_icons(value)
	
