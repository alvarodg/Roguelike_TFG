extends Control
## Clase base para las escenas de eventos. Tiene una posible referencia al siguiente evento a encadenar
## y una función finish que se encarga de crearlo si existe e indicar que ha terminado cuando todos los
## eventos encadenados hayan acabado.
class_name EventScene

signal finished

var next_level_scene = load("res://Menus/next_level.tscn")
var win_scene = load("res://Menus/win_screen.tscn")

var player: Player
var next_event: EventData
var goes_to_next_level: bool
var is_final_event: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(p_player: Player, data):
	player = p_player
	next_event = data.next_event
	goes_to_next_level = data.goes_to_next_level
	is_final_event = data.is_final_event

func finish():
	if next_event is EventData:
		var next_scene = next_event.instantiate_scene(player)
		get_parent().add_child(next_scene)
		hide()
		await next_scene.finished
	if is_final_event:
		get_parent().hide()
		get_tree().root.add_child(win_scene.instantiate())
	if goes_to_next_level:
		get_parent().hide()
		get_tree().root.add_child(next_level_scene.instantiate())
	finished.emit()
	queue_free()
