extends HBoxContainer

@onready var coin_scene = preload("res://Battle/prototypes/coin.tscn")
# Sacar del jugador en la implementación final
@export var coin_count: int  = 6
@export var luck: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(coin_count):
		var coin = coin_scene.instantiate()
		coin.flip()
		add_child(coin)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
