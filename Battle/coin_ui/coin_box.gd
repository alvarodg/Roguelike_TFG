extends GridContainer

@onready var turn_manager: TurnManager = preload("res://Battle/resources/TurnManager.tres")
@onready var coin_scene = preload("res://Battle/coin_ui/coin.tscn")
# Sacar del jugador en la implementación final
@export var coin_count: int  = 6
@export var luck: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	turn_manager.player_turn_started.connect(_on_player_turn_started)
	turn_manager.enemy_turn_started.connect(_on_enemy_turn_started)

func setup(player: Player):
	coin_count = player.stats.coin_count
	luck = player.stats.base_luck
	player.coins_changed.connect(_on_Player_coins_changed)
	for coin in player.coins:
		add_child(coin)
#	for i in range(coin_count):
#		var coin = coin_scene.instantiate()
#		coin.add_to_group("coin")
#		coin.flip(luck)
#		add_child(coin)

func make_coins_available():
	for coin in get_children():
		if coin is Coin:
			coin.status = Coin.Status.AVAILABLE

func flip_all_coins():
	for coin in get_children():
		if coin is Coin:
			coin.flip(luck)

# La responsibilidad de liberar las monedas efímeras al final del turno queda en CoinBox.
func clear_ephemeral_coins():
	for coin in get_children():
		if coin is Coin and coin.is_ephemeral:
			coin.queue_free()

func _on_Player_coins_changed(new_coins):
	for coin in get_children():
		if coin is Coin:
			remove_child(coin)
	for coin in new_coins:
		add_child(coin)

func _on_player_turn_started():
	flip_all_coins()

func _on_enemy_turn_started():
	clear_ephemeral_coins()
