extends Resource
class_name CoinData

@export var heads_texture: Texture2D
@export var tails_texture: Texture2D
@export var heads_chance: float = 0.5
var default_heads = true
var coin_scene = preload("res://Battle/coin_ui/coin.tscn")

func create_coin_instance(ephemeral = false):
	var coin: Coin = coin_scene.instantiate()
	coin.setup(self)
	coin.is_ephemeral = ephemeral
	return coin
