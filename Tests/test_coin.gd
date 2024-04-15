extends Control

@onready var coin_container = $CoinContainer

@export var coin_data: Array[CoinData]

# Called when the node enters the scene tree for the first time.
func _ready():
	for data in coin_data:
		var coin: Coin = data.create_coin_instance()
		coin_container.add_child(coin)
		coin.start_spinning()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
