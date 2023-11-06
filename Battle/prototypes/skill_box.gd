extends VBoxContainer

# ¿Indices mejor que objetos?
# Sacar de la propia habilidad en la implementación final.
@export var slot_list: Array[int]
@onready var slot_scene = preload("res://Battle/prototypes/slot.tscn")
@onready var description = %Description
@onready var slot_box = %SlotBox
@onready var execute_button = %ExecuteButton
@onready var undo_button = %UndoButton
var coin_list: Array[Coin]

# Called when the node enters the scene tree for the first time.
func _ready():
	execute_button.disabled = true
	undo_button.disabled = true
	for slot_index in slot_list:
		var slot = slot_scene.instantiate()
		# Hacky, cambiar.
		if slot_index == 0:
			slot.set_heads_only()
		elif slot_index == 1:
			slot.set_tails_only()
		else:
			slot.set_any()
		slot.add_to_group("slots")
		slot_box.add_child(slot)
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
	print(slot_list)
	for slot in slots:
		slot.release_coin()

func connect_to_slot_signals(slot: Slot):
	slot.coin_inserted.connect(_on_Slot_coin_inserted)

func _on_Slot_coin_inserted(coin):
	undo_button.disabled = false
	coin_list.append(coin)
	if coin_list.size() == slot_list.size():
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
