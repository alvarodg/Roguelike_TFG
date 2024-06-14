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
var unique: bool
var goes_to_next_level: bool
var is_final_event: bool
var event_unlocks: Array[EventData]

var data_backup

# Called when the node enters the scene tree for the first time.
func _ready():
	RunData.current_event_scene = self
#	pass # Replace with function body.

func initialize(p_player: Player, data):
	data_backup = data
	player = p_player
	next_event = data.next_event
	unique = data.unique
	goes_to_next_level = data.goes_to_next_level
	is_final_event = data.is_final_event
	event_unlocks = data.event_unlocks

func finish():
	if RunData.current_event_scene == self:
		# Acceso al singleton RunData para modificar la escena actual
		RunData.current_event_scene = null
	if unique:
		# Acceso al singleton RunData para que el evento no vuelva a aparecer aleatoriamente.
		RunData.collections.remove(data_backup)
	if event_unlocks != null:
		for event in event_unlocks:
			# Acceso al singleton RunData para añadir los eventos a la colección.
			RunData.collections.add(event)
	if next_event is EventData:
		var next_scene = next_event.instantiate_scene(player)
		get_parent().add_child(next_scene)
		hide()
		await next_scene.finished
	if is_final_event:
		# Si es el último evento, carga la escena de victoria
		get_parent().hide()
		get_tree().root.add_child(win_scene.instantiate())
	elif goes_to_next_level:
		# Si pasa al siguiente nivel, carga la escena de cambio de nivel
		get_parent().hide()
		get_tree().root.add_child(next_level_scene.instantiate())
	finished.emit()
	queue_free()
