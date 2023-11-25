extends Control

@onready var turn_manager: TurnManager = preload("res://Battle/resources/TurnManager.tres")
@onready var coin_box_container = %CoinBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func setup(player: Player):
	player.coins_changed.connect(_on_Player_coins_changed)
	for coin in player.coins:
		coin_box_container.add_child(coin)
#	coin_box_container.get_child(0).grab_focus()

func _on_Player_coins_changed(new_coins):
	for coin in coin_box_container.get_children():
		if coin is Coin:
			coin_box_container.remove_child(coin)
	for coin in new_coins:
		coin_box_container.add_child(coin)
