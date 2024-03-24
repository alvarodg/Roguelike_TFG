extends Control
class_name EnemySkillIcon

@export var skill: SkillData

@onready var hidden_icon = preload("res://Battle/skills/icons/unknown_skill.png")

@onready var sprite = %Sprite
@onready var shadow = %Shadow
@onready var info_label = %InfoLabel
@onready var info_panel = %InfoPanel

enum State {ACTIVE, INACTIVE, HIDDEN}

var state: State : set = set_state

# Called when the node enters the scene tree for the first time.
func _ready():
	info_label.hide()
	info_label.text = skill.ui_data.ui_name + ":\n" + skill.get_description()
	state = State.ACTIVE

func setup(p_skill: SkillData):
	skill = p_skill

func apply_stats(stats: CombatantStats):
	info_label.text = skill.ui_data.ui_name + ":\n" + skill.get_description(stats)
	
func set_state(value: State):
	state = value
	match state:
		State.ACTIVE:
			sprite.texture = skill.ui_data.icon
			shadow.hide()
		State.INACTIVE:
			sprite.texture = skill.ui_data.icon
			shadow.show()
		State.HIDDEN:
			sprite.texture = hidden_icon
			shadow.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	if state != State.HIDDEN:
		info_label.show()


func _on_mouse_exited():
	info_label.hide()
