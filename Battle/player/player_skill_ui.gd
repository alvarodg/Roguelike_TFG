extends Control

@onready var skill_grid = %SkillGrid
@onready var skill_box_scene = preload("res://Battle/coin_ui/skill_box.tscn")
@onready var input_blocker = $InputBlocker

var current_coin: Coin = null
var coinbox: CoinBox = null

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	EventBus.found_coin.connect(_on_coin_found)

func setup(player: Player, p_coinbox: CoinBox = null):
	player.stats_changed.connect(_on_Player_stats_changed)
	for skill_data in player.skill_list:
		var skill_box = skill_box_scene.instantiate()
		skill_box.setup(skill_data)
		skill_grid.add_child(skill_box)
		skill_box.apply_stats(player.stats)
		skill_box.slot_was_pressed.connect(_on_SkillBox_slot_was_pressed)
	coinbox = p_coinbox

# Cuando se hace click en una ranura, si se tiene una moneda seleccionada, la inserta.
func _on_SkillBox_slot_was_pressed(slot: Slot):
	if current_coin != null and slot.is_coin_compatible(current_coin.heads):
		EventBus.released_selected.emit(current_coin)
		slot.insert_coin(current_coin)
		current_coin = null
	elif current_coin == null:
		if coinbox != null:
			current_coin = coinbox.request_coin(slot.facing)
		if current_coin != null: 
			EventBus.released_selected.emit(current_coin)
			print(slot)
			slot.insert_coin(current_coin)
			current_coin = null
	elif not slot.is_coin_compatible(current_coin.heads) and current_coin.status == Coin.Status.AVAILABLE:
		current_coin.grab_focus()
		

# Si focus cambia a una moneda, guarda una referencia.
func _on_focus_changed(current_focus):
	if current_focus is Coin:
		if (current_coin != null and not current_coin.is_queued_for_deletion() 
				and current_coin.status == Coin.Status.AVAILABLE): 
			EventBus.released_selected.emit(current_coin)
		current_coin = current_focus
		EventBus.was_selected.emit(current_coin)


func _on_coin_found(coin):
	if coin is Coin and coin.status == Coin.Status.AVAILABLE:
		coin.grab_focus()

func _on_Player_stats_changed(value):
	for skill in skill_grid.get_children():
		if skill is SkillBox: skill.apply_stats(value)

func block_input():
	input_blocker.mouse_filter = MOUSE_FILTER_STOP
	
func allow_input():
	input_blocker.mouse_filter = MOUSE_FILTER_IGNORE
