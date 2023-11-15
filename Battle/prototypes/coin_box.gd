extends GridContainer

@onready var turn_manager: TurnManager = preload("res://Battle/resources/TurnManager.tres")
@onready var coin_scene = preload("res://Battle/prototypes/coin.tscn")
# Sacar del jugador en la implementación final
@export var coin_count: int  = 6
@export var luck: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	turn_manager.player_turn_started.connect(_on_player_turn_started)
#	for i in range(coin_count):
#		var coin = coin_scene.instantiate()
#		coin.add_to_group("coin")
#		coin.flip()
#		add_child(coin)

func setup(player_stats: PlayerStats):
	coin_count = player_stats.coin_count
	luck = player_stats.base_luck
	for i in range(coin_count):
		var coin = coin_scene.instantiate()
		coin.add_to_group("coin")
		coin.flip(luck)
		add_child(coin)

func make_coins_available():
	for coin in get_children():
		if coin is Coin:
			coin.status = Coin.Status.AVAILABLE

func flip_all_coins():
	for coin in get_children():
		if coin is Coin:
			coin.flip(luck)

func _on_player_turn_started():
	flip_all_coins()
