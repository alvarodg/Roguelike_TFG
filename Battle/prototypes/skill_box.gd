extends VBoxContainer

@export var skill: Skill
@onready var slot_scene = preload("res://Battle/prototypes/slot.tscn")
@onready var description = %Description
@onready var slot_box = %SlotBox
@onready var execute_button = %ExecuteButton
@onready var undo_button = %UndoButton
var coin_list: Array[Coin]
var total_coins: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	execute_button.disabled = true
	undo_button.disabled = true
	var slot_list = skill.get_coin_cost()
	# Hacky, mira hasta los tres primeros elementos de la lista y asigna a coints_needed
	for i in range(min(slot_list.size(),3)):
		if slot_list[i] > 0:
			var slot: Slot = slot_scene.instantiate()
			if i == 0:
				slot.set_any()
			elif i == 1:
				slot.set_heads_only()
			else:
				slot.set_tails_only()
			slot.add_to_group("slots")
			slot_box.add_child(slot)
			slot.coins_needed = slot_list[i]
			total_coins += slot.coins_needed
			connect_to_slot_signals(slot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func release_coins():
	coin_list = []
	var slots = []
	for node in slot_box.get_children():
		if node.is_in_group("slots"):
			slots.append(node)
	for slot in slots:
		slot.release_coin()

func connect_to_slot_signals(slot: Slot):
	slot.coin_inserted.connect(_on_Slot_coin_inserted)

func _on_Slot_coin_inserted(coin):
	undo_button.disabled = false
	coin_list.append(coin)
	if coin_list.size() == total_coins:
		execute_button.disabled = false


func _on_UndoButton_pressed():
	print("Funciona")
	release_coins()
	undo_button.disabled = true
	execute_button.disabled = true


func _on_ExecuteButton_pressed():
	description.text = "ALGO HECHO"
	undo_button.disabled = true
	execute_button.disabled = true
