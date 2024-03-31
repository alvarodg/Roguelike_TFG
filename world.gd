extends Control

signal game_ready

var node_matrix = []
var traveled_nodes: Array[EventNode] = []
var traveled_coords: Array[Vector2] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.new_run_selected.connect(_on_new_run)
	EventBus.continue_run_selected.connect(_on_continue_run)

func _on_new_run():
	await ScreenTransitions.fade_to_black()
	RunData.map.start_game(RunData.player, RunData.rng)
	game_ready.emit()
	ScreenTransitions.fade_from_black()

func _on_continue_run():
	await ScreenTransitions.fade_to_black()
	RunData.load_game()
	RunData.map.start_game(RunData.player, RunData.rng)
	game_ready.emit()
	ScreenTransitions.fade_from_black()

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
