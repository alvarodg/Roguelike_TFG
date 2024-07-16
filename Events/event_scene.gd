extends Control
## Clase base para las escenas de eventos. Tiene una posible referencia al siguiente evento a encadenar
## y una función finish que se encarga de crearlo si existe e indicar que ha terminado cuando todos los
## eventos encadenados hayan acabado.
class_name EventScene

signal finished

# Referencia a la escena de cambio de nivel
var next_level_scene = load("res://Menus/next_level.tscn")
# Referencia a a la escena de victoria
var win_scene = load("res://Menus/win_screen.tscn")

# Jugador que está participando en el evento
var player: Player
# Siguiente evento que se iniciará al terminar este
var next_event: EventData
# Un evento único se borrará de la lista de eventos posibles una vez terminado
var unique: bool
# Un evento que va al siguiente nivel pasará al siguiente nivel sin importar
# su posición en el mapa cuando termine.
var goes_to_next_level: bool
# Un evento final pasará a la escena de fin de partida
# su posición en el mapa cuando termine.
var is_final_event: bool
# Lista de eventos que se añadirán a la lista de posibles una vez termine este
var event_unlocks: Array[EventData]

# Guarda una copia del objeto de datos con el que se inicializa el evento 
# en esta variable, útil para modificar la lista de eventos
var data_backup

# Called when the node enters the scene tree for the first time.
func _ready():
	# Designa el evento como evento actual de la partida
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
		# Acceso al singleton RunData para modificar la escena actual,
		# quitando la escena actual ya que ha terminado
		RunData.current_event_scene = null
	# Si el evento es único
	if unique:
		# Acceso al singleton RunData para que el evento no vuelva 
		# a aparecer aleatoriamente.
		RunData.collections.remove(data_backup)
	# Si hay eventos que desbloquear
	if event_unlocks != null:
		for event in event_unlocks:
			# Acceso al singleton RunData para añadir los eventos a la colección.
			RunData.collections.add(event)
	# Si hay un evento siguiente, lo encadena
	if next_event is EventData:
		var next_scene = next_event.instantiate_scene(player)
		get_parent().add_child(next_scene)
		hide()
		await next_scene.finished
	# Si es el último evento, carga la escena de victoria
	if is_final_event:
		get_parent().hide()
		get_tree().root.add_child(win_scene.instantiate())
	# Si pasa al siguiente nivel, carga la escena de cambio de nivel
	elif goes_to_next_level:
		get_parent().hide()
		get_tree().root.add_child(next_level_scene.instantiate())
	finished.emit()
	queue_free()
