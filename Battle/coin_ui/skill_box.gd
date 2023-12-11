extends Control
class_name SkillBox

signal slot_was_pressed

@onready var combatants: Combatants = preload("res://Battle/resources/Combatants.tres")
@onready var turn_manager: TurnManager = preload("res://Battle/resources/TurnManager.tres")
@export var skill_data: SkillData
@onready var slot_scene = preload("res://Battle/coin_ui/slot.tscn")
@onready var skill_box_container = %SkillBoxContainer
@onready var name_label = %NameLabel
@onready var description_label = %DescriptionLabel
@onready var slot_box = %SlotBox
@onready var uses_label = %UsesLabel
@onready var button_container = %ButtonContainer
@onready var execute_button = %ExecuteButton
@onready var undo_button = %UndoButton
var coin_list: Array[Coin]
var total_coins: int = 0
var skill_uses: int : set = set_skill_uses
var spent: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(skill_data is SkillData)
	skill_uses = skill_data.uses_per_turn
	turn_manager.player_turn_started.connect(_on_Player_turn_started)
	execute_button.disabled = true
	undo_button.disabled = true
	name_label.text = skill_data.name
	description_label.text = skill_data.get_description()
	_update_uses_ui()
	if skill_data.one_shot:
		uses_label.set("theme_override_colors/font_color", Color.DARK_GOLDENROD)
	var slot_list = skill_data.cost
	# Hacky, mira hasta los tres primeros elementos de la lista y asigna a coints_needed
	for i in range(min(slot_list.size(),3)):
		if slot_list[i] > 0:
			# Asigna las monedas que acepta a la ranura.
			var slot: Slot = slot_scene.instantiate()
			if i == 0:
				slot.facing = Coin.Facing.ANY
			elif i == 1:
				slot.facing = Coin.Facing.HEADS
			else:
				slot.facing = Coin.Facing.TAILS
			slot.add_to_group("slots")
			slot_box.add_child(slot)
			slot.coins_needed = slot_list[i]
			total_coins += slot.coins_needed
			connect_to_slot_signals(slot)

func setup(p_skill_data: SkillData):
	skill_data = p_skill_data
	
func release_inserted_coins():
	coin_list = []
	var slots = []
	for node in slot_box.get_children():
		if node.is_in_group("slots"):
			slots.append(node)
	for slot in slots:
		slot.release_inserted_coins()

func release_all_coins():
	coin_list = []
	var slots = []
	for node in slot_box.get_children():
		if node.is_in_group("slots"):
			slots.append(node)
	for slot in slots:
		slot.release_all_coins()

func connect_to_slot_signals(slot: Slot):
	slot.coin_inserted.connect(_on_Slot_coin_inserted)
	slot.was_pressed.connect(_on_Slot_was_pressed)

func _on_Slot_coin_inserted(coin):
	undo_button.disabled = false
	coin_list.append(coin)
	if coin_list.size() == total_coins or not skill_data.cost_is_mandatory:
		execute_button.disabled = false

func _on_Slot_was_pressed(slot):
	slot_was_pressed.emit(slot)

func _on_UndoButton_pressed():
	print("Undone")
	release_inserted_coins()
	undo_button.disabled = true
	execute_button.disabled = true


func _on_ExecuteButton_pressed():
	if skill_uses != 0:
		skill_uses -= 1
		var skill = skill_data.create_skill(combatants.player, combatants.enemy, coin_list)
		# Marca las monedas como usadas antes de usar la habilidad, importante para poder cambiar su estado en esta.
		for slot in slot_box.get_children():
			if slot is Slot:
				slot.use_coins()
		skill.use()
		undo_button.disabled = true
		execute_button.disabled = true
		if skill_uses != 0:
			for slot in slot_box.get_children():
				if slot is Slot:
					slot.set_available()
			coin_list = []
		# Si la habilidad no es reutilizable, guarda que se ha usado cuando se quede sin usos.
		if skill_uses == 0: spent = skill_data.one_shot

func _on_Player_turn_started():
	release_all_coins()
	if spent:
		for slot in slot_box.get_children():
			if slot is Slot: slot.set_unavailable()
	else:
		if not skill_data.one_shot:
			skill_uses = skill_data.uses_per_turn
		undo_button.disabled = true
		execute_button.disabled = true

func set_skill_uses(value):
	skill_uses = value
	_update_uses_ui()

func hide_buttons():
	button_container.hide()

func remove_buttons():
	var height = execute_button.size.y
	button_container.queue_free()
	custom_minimum_size.y -= height

func _update_uses_ui():
	if skill_data.uses_per_turn < 0:
		uses_label.text = "x ∞"
	else:
		uses_label.text = "x "+str(skill_uses)
