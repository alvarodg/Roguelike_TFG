extends Control

@onready var turn_manager: TurnManager = preload("res://Battle/resources/TurnManager.tres")
@onready var coin_box_container = %CoinBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.coin_inserted.connect(_on_coin_inserted)
	EventBus.looking_for_coin.connect(_on_coin_requested)

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

func _on_coin_inserted(slot: Slot, coin: Coin):
	if slot.coins_needed != slot.inserted_coins.size():
		_set_focus_coin(slot.facing)
	else:
		_set_focus_coin(Coin.Facing.ANY)

func _set_focus_coin(facing: Coin.Facing):
	var chosen_coin: Coin = null
	for coin in coin_box_container.get_children():
		if coin is Coin and coin.status == Coin.Status.AVAILABLE and coin.check_facing(facing):
			chosen_coin = coin
			break
	if chosen_coin != null: 
		chosen_coin.is_selected = true
		chosen_coin.grab_focus()

func _on_coin_requested(facing: Coin.Facing = Coin.Facing.ANY):
	var chosen_coin: Coin = null
	for coin in coin_box_container.get_children():
		if coin is Coin and coin.status == Coin.Status.AVAILABLE and coin.check_facing(facing):
			chosen_coin = coin
			break
	EventBus.found_coin.emit(chosen_coin)
