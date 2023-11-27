extends Control

@onready var skill_grid = %SkillGrid
@onready var skill_box_scene = preload("res://Battle/coin_ui/skill_box.tscn")

var current_coin: Coin = null

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
#	pass # Replace with function body.

func setup(player: Player):
	for skill_data in player.skill_list:
		var skill_box = skill_box_scene.instantiate()
		skill_box.setup(skill_data)
		skill_grid.add_child(skill_box)
		skill_box.slot_was_pressed.connect(_on_SkillBox_slot_was_pressed)

# Cuando se hace click en una ranura, si se tiene una moneda seleccionada, la inserta.
func _on_SkillBox_slot_was_pressed(slot):
	if slot.insert_coin(current_coin):
		EventBus.released_selected.emit(current_coin)
		current_coin = null


# Si focus cambia a una moneda, guarda una referencia.
func _on_focus_changed(current_focus):
	if current_focus is Coin:
		EventBus.released_selected.emit(current_coin)
		current_coin = current_focus
		EventBus.was_selected.emit(current_coin)
