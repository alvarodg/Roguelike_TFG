extends Control

@onready var player_stats_ui = $PlayerStatsUI
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player_stats_ui.setup(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
