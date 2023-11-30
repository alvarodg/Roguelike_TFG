extends Control

signal ready_to_load
signal event_chosen

@export var debug_start: bool = false
@onready var generator = $Generator
@onready var player_map_ui = %PlayerMapUI
@onready var reset_button = %ResetButton

var node_matrix = []
var traveled_nodes: Array[EventNode] = []
var traveled_coords: Array[Vector2] = []
var current_event: Event

# Called when the node enters the scene tree for the first time.
# Usando la señal game_ready para asegurarse de que terminen de asignarse sus datos en data_load()
# cuando se carga partida.
func _ready():
	player_map_ui.hide()
	reset_button.hide()
	if debug_start:
		print("DEBUG START SET")
		_on_World_game_ready()
		return
	get_parent().connect("game_ready", _on_World_game_ready)
	add_to_group("map_screen")
	

func start_game(player: Player, run_seed: int):
	generator.generate(run_seed)
	player_map_ui.setup(player)
	player_map_ui.show()
	reset_button.show()

## Al recibir la señal generation_complete de Generator, guarda los nodos generados,
## marca la primera tanda como disponible y se conecta a sus señales.
func _on_Generator_generation_complete(p_node_matrix):
	node_matrix = p_node_matrix
	refresh_map()
	connect_to_node_signals(node_matrix)
	RunData.save_game()

## Cuando se recibe la señal node_chosen de EventNode deja a todos los nodos sin disponibilidad, 
## añade el nodo que la mandó a la lista de atravesados y marca a los miembros de esta lista 
## como tales y, finalmente, marca a sus descendientes como disponibles.
func _on_EventNode_chosen(node: EventNode):
	traveled_nodes.append(node)
	traveled_coords.append(node.coordinates)
	remove_availability()
	mark_traveled()
	make_descendants_available(node)
	for map_screen_node in get_tree().get_nodes_in_group("map_screen"):
		map_screen_node.hide()
	var event_scene = node.instantiate_event_scene()
	get_parent().add_child(event_scene)
	await event_scene.finished
	for map_screen_node in get_tree().get_nodes_in_group("map_screen"):
		map_screen_node.show()
	RunData.save_game()


#func _on_Event_finished():
#	for map_screen_node in get_tree().get_nodes_in_group("map_screen"):
#		map_screen_node.show()

## Conecta las señales que se van a utilizar de todos los nodos en node_matrix
func connect_to_node_signals(p_node_matrix):
	for i in range(p_node_matrix.size()):
		for j in range(p_node_matrix[i].size()):
			p_node_matrix[i][j].connect("node_chosen", _on_EventNode_chosen)

## Actualiza el estado de navegación de los nodos visitados.
func mark_traveled():
	for node in traveled_nodes:
		node.state = EventNode.State.TRAVELED

## Marca todos los nodos como no disponibles.
func remove_availability():
	for i in range(node_matrix.size()):
		for j in range(node_matrix[i].size()):
			node_matrix[i][j].state = EventNode.State.UNAVAILABLE

## Marca los nodos descientes de nodo como disponibles.
func make_descendants_available(node):
	for descendant in node.descendants:
		descendant.state = EventNode.State.AVAILABLE

func reassign_traveled():
	traveled_nodes = []
	for coords in traveled_coords:
		traveled_nodes.append(node_matrix[coords.x][coords.y])

func refresh_map():
	reassign_traveled()
	remove_availability()
	if traveled_coords.size() > 0:
		mark_traveled()
		make_descendants_available(traveled_nodes.back())
	else:
		for node in node_matrix[0]:
			node.state = EventNode.State.AVAILABLE
	

func _on_RegenerateButton_pressed():
	generator.generate(RunData.run_seed)

func _on_World_game_ready():
#	generator.generate(RunData.run_seed)
	start_game(RunData.player, RunData.run_seed)
	
# Función que trata los parámetros a guardar, devolviéndolos en un diccionario.
func save():
	var traveled_coords_x = []
	var traveled_coords_y = []
	for i in range(traveled_coords.size()):
		traveled_coords_x.append(traveled_coords[i].x)
		traveled_coords_y.append(traveled_coords[i].y)
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"traveled_coords_x" : traveled_coords_x,
		"traveled_coords_y" : traveled_coords_y
	}
	return save_dict

# Función que trata los parámetros guardados y los carga.
func data_load(parameter, data):
	if parameter == "traveled_coords_x":
		for i in range(data.size()):
			if traveled_coords.size() == data.size():
				traveled_coords[i].x = data[i]
			else:
				traveled_coords.append(Vector2(data[i],0))
	elif parameter == "traveled_coords_y":
		for i in range(data.size()):
			if traveled_coords.size() == data.size():
				traveled_coords[i].y = data[i]
			else:
				traveled_coords.append(Vector2(0, data[i]))
	else:
		set(parameter, data)


func _on_ResetButton_pressed():
	RunData.delete_save(true)
	get_tree().change_scene_to_file("res://Menus/loss_screen.tscn")
