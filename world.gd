extends Control

signal game_ready

var map: Map

var node_matrix = []
var traveled_nodes: Array[EventNode] = []
var traveled_coords: Array[Vector2] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.new_run_selected.connect(_on_new_run)
	EventBus.continue_run_selected.connect(_on_continue_run)
	
# Se llama a esta función desde Map para arreglar la doble generación
func assign_map(p_map: Map):
	map = p_map
	print(map)

func _on_new_run():
	game_ready.emit()
	map.start_game(RunData.player, RunData.run_seed)

func _on_continue_run():
	RunData.load_game()
	map.start_game(RunData.player, RunData.run_seed)
	game_ready.emit()

func _on_SaveButton_pressed():
	RunData.save_game()
#	refresh_map()

func _on_LoadButton_pressed():
	pass
#	EventBus.continue_run_selected.emit()
#	RunData.load_game()
#	refresh_map()

func _on_DeleteSave_pressed():
	RunData.delete_save(true)
