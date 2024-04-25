extends Control
## Clase base para las escenas de eventos. Tiene una posible referencia al siguiente evento a encadenar
## y una función finish que se encarga de crearlo si existe e indicar que ha terminado cuando todos los
## eventos encadenados hayan acabado.
class_name EventScene

signal finished

var player: Player
var next_event: EventData

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func finish():
	if next_event is EventData:
		var next_scene = next_event.instantiate_scene(player)
		get_parent().add_child(next_scene)
		hide()
		await next_scene.finished
	finished.emit()
	queue_free()
