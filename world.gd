extends Control

signal game_loaded

var node_matrix = []
var traveled_nodes: Array[EventNode] = []
var traveled_coords: Array[Vector2] = []

# Temporal, para probar guardar/cargar en variable
var saved_coords: Array[Vector2] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("game_loaded")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_SaveButton_pressed():
	RunData.save_game()
#	refresh_map()

func _on_LoadButton_pressed():
	RunData.load_game()
#	refresh_map()

func _on_DeleteSave_pressed():
	DirAccess.copy_absolute("user://savegame.save", "user://savegame.backup")
	DirAccess.remove_absolute("user://savegame.save")
