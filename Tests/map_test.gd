extends Control

@onready var player = $Player
@onready var map = $Map

@export var run_seed: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	if run_seed != -1:
		rng.seed = run_seed
	RunData.rng = rng
	map.start_game(player, rng)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
