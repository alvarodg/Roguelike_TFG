extends Control

@onready var skill_grid = %SkillGrid
@onready var skill_box_scene = preload("res://Battle/coin_ui/skill_box.tscn")

var current_coin: Coin = null
var player: Player
# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	EventBus.found_coin.connect(_on_coin_found)
#	pass # Replace with function body.

func setup(p_player: Player):
	player = p_player
	player.stats.strength_changed.connect(_on_Player_stats_changed)
	for skill_data in player.skill_list:
		var skill_box = skill_box_scene.instantiate()
		skill_box.setup(skill_data)
		skill_grid.add_child(skill_box)
		skill_box.apply_stats(player)
		skill_box.slot_was_pressed.connect(_on_SkillBox_slot_was_pressed)

# Cuando se hace click en una ranura, si se tiene una moneda seleccionada, la inserta.
func _on_SkillBox_slot_was_pressed(slot: Slot):
	if current_coin != null and slot.is_coin_compatible(current_coin.heads):
		EventBus.released_selected.emit(current_coin)
		slot.insert_coin(current_coin)
		current_coin = null
	elif current_coin == null:
		# Parece funcionar perfectamente, ¿es posible que la señal no llegue a tiempo?
		EventBus.looking_for_coin.emit(slot.facing)
		if current_coin != null: 
			EventBus.released_selected.emit(current_coin)
			print(slot)
			slot.insert_coin(current_coin)
			current_coin = null
	elif not slot.is_coin_compatible(current_coin.heads):
		current_coin.grab_focus()
		

# Si focus cambia a una moneda, guarda una referencia.
func _on_focus_changed(current_focus):
	if current_focus is Coin:
		if current_coin != null and not current_coin.is_queued_for_deletion(): EventBus.released_selected.emit(current_coin)
		current_coin = current_focus
		EventBus.was_selected.emit(current_coin)


func _on_coin_found(coin):
	if coin is Coin:
		coin.grab_focus()

func _on_Player_stats_changed(_value):
	for skill in skill_grid.get_children():
		if skill is SkillBox: skill.apply_stats(player)
