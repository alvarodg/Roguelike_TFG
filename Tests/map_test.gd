extends Control

@onready var player = $Player
@onready var map = $Map

@export var run_seed: int

# Called when the node enters the scene tree for the first time.
func _ready():
	map.start_game(player, run_seed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
