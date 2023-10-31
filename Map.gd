extends Control

signal ready_to_load

@onready var generator = %Generator

var node_matrix = []
var traveled_nodes: Array[EventNode] = []
var traveled_coords: Array[Vector2] = []
# Temporal, para probar guardar/cargar en variable
var saved_coords: Array[Vector2] = []

# Called when the node enters the scene tree for the first time.
# Usando call_deferred para asegurarse de que termine de asignarse sus datos en data_load()
# cuando se carga partida.
func _ready():
	call_deferred("_start")
#	get_parent().connect("game_loaded", _on_World_game_loaded)

func _start():
	generator.generate()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


## Al recibir la señal generation_complete de Generator, guarda los nodos generados,
## marca la primera tanda como disponible y se conecta a sus señales.
func _on_Generator_generation_complete(p_node_matrix):
	node_matrix = p_node_matrix
	refresh_map()
	connect_to_node_signals(node_matrix)

## Cuando se recibe la señal node_chosen de EventNode deja a todos los nodos sin disponibilidad, 
## añade el nodo que la mandó a la lista de atravesados y marca a los miembros de esta lista 
## como tales y, finalmente, marca a sus descendientes como disponibles.
func _on_EventNode_chosen(node: EventNode):
	traveled_nodes.append(node)
	traveled_coords.append(node.coordinates)
	remove_availability()
	mark_traveled()
	make_descendants_available(node)

## Conecta las señales que se van a utilizar de todos los nodos en node_matrix
func connect_to_node_signals(node_matrix):
	for i in range(node_matrix.size()):
		for j in range(node_matrix[i].size()):
			node_matrix[i][j].connect("node_chosen", _on_EventNode_chosen)

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
	

#func load_game():
#	traveled_coords = saved_coords.duplicate()

func _on_RegenerateButton_pressed():
	generator.generate()

func _on_World_game_loaded():
	generator.generate()

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
	saved_coords = traveled_coords.duplicate()
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
