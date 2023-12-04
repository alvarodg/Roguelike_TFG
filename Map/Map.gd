extends Control

signal ready_to_load
signal event_chosen

@export var debug_start: bool = false
@export var generation_data_list: Array[GenerationData]
@onready var generator = $Generator
@onready var player_map_ui = %PlayerMapUI
@onready var reset_button = %ResetButton

var current_level: int = 0
var level_list = []
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
	for i in range(generation_data_list.size()):
		var level = generator.generate(generation_data_list[i], run_seed)
		level_list.append(level)
#	generator.generate(run_seed)
	player_map_ui.setup(player)
	player_map_ui.show()
	reset_button.show()
	set_level(current_level)


func set_level(level_id: int):
	node_matrix = level_list[level_id]
	# De momento no guarda los nodos visitados en previos niveles, modificar si se quiere hacer algo con ellos.
	for child in generator.get_children():
		generator.remove_child(child)
	for i in range(node_matrix.size()):
		for j in range(node_matrix[i].size()):
			generator.add_child(node_matrix[i][j])
	refresh_map()
	connect_to_node_signals(node_matrix)
	RunData.save_game()
	

func change_level(level_id: int):
	traveled_nodes = []
	traveled_coords = []
	set_level(level_id)

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
			# Asegurase de no reconectar, solo útil si se planean reutilizar niveles en la misma partida.
			if not p_node_matrix[i][j].node_chosen.is_connected(_on_EventNode_chosen):
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
	var gen_data_path = []
	# Guarda GenerationData a partir de su localización en disco, por lo que se deben utilizar recursos
	# explícitamente creados (facilita mayormente el guardado/cargado)
	for gen_data in generation_data_list:
		gen_data_path.append(gen_data.resource_path)
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"traveled_coords_x" : traveled_coords_x,
		"traveled_coords_y" : traveled_coords_y,
		"current_level" : current_level,
		"generation_data_list" : gen_data_path
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
	elif parameter == "generation_data_list":
		for path in data:
			generation_data_list.append(load(path))
	else:
		set(parameter, data)


func _on_ResetButton_pressed():
	RunData.delete_save(true)
	get_tree().change_scene_to_file("res://Menus/loss_screen.tscn")


func _on_ChangeLevelButton_pressed():
	current_level = current_level+1 if current_level+1 < generation_data_list.size() else 0
	change_level(current_level)
