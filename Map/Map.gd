extends Control
class_name Map

signal ready_to_load
signal event_chosen

@export var debug: bool = false
@export var generation_data_list: Array[GenerationData]
@onready var generator = $Generator
@onready var player_map_ui = %PlayerMapUI
@onready var reset_button = %ResetButton
@onready var change_level_button = %ChangeLevelButton
@onready var navigation_button = %NavigationButton

var current_level: int = 0
var level_list = []
var node_matrix = []
var traveled_nodes: Array[EventNode] = []
var traveled_coords: Array[Vector2] = []
var current_event: Event

#var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Acceso al singleton
	RunData.map = self
	player_map_ui.hide()
	reset_button.hide()
	navigation_button.hide()
	change_level_button.hide()
	EventBus.level_finished.connect(_on_level_finished)
	add_to_group("map_screen")
	add_to_group("run_persistent")

#func _process(delta):
#	counter += 1
#	if counter >= 60:
#		counter = 0
#		print(RunData.rng.state)

func start_game(player: Player, rng: RandomNumberGenerator):
	for i in range(generation_data_list.size()):
		var level = generator.generate(generation_data_list[i], rng)
		level_list.append(level)
	player_map_ui.setup(player)
	player_map_ui.show()
	if debug:
		reset_button.show()
		change_level_button.show()
		navigation_button.show()
	else:
		reset_button.hide()
		change_level_button.hide()
		navigation_button.hide()
	set_level(current_level)
	print("started")
	await ScreenTransitions.fade_from_black()
	EventBus.level_generation_completed.emit()
#	await RunData.finished_loading
#	RunData.reload_rng()
	
func _on_level_finished():
	get_parent().show()
	if current_level+1 < level_list.size():
		change_level(current_level+1)
	else:
		finish_run()
		
## Quita los nodos actuales si existen, añade los nodos del nivel indicado, 
## marca la primera tanda como disponible y se conecta a sus señales.
func set_level(level_id: int):
	print("Setting level " + str(level_id))
	node_matrix = level_list[level_id]
	current_level = level_id
	# De momento no guarda los nodos visitados en previos niveles, modificar si se quiere hacer algo con ellos.
	for child in generator.get_children():
		generator.remove_child(child)
	for i in range(node_matrix.size()):
		for j in range(node_matrix[i].size()):
			generator.add_child(node_matrix[i][j])
	refresh_map()
	connect_to_node_signals(node_matrix)
	print("set")
	RunData.save_game()

	

## Para cambiar de nivel, primero vacía las listas de nodos por los que se ha viajado.
func change_level(level_id: int):
	get_parent().hide()
	await ScreenTransitions.fade_to_black()
	traveled_nodes = []
	traveled_coords = []
	set_level(level_id)
	get_parent().show()
	ScreenTransitions.fade_from_black()


func finish_run():
	# TEMPORAL, crear escena
	print("You won!")

## Cuando se recibe la señal node_chosen de EventNode deja a todos los nodos sin disponibilidad, 
## añade el nodo que la mandó a la lista de atravesados y marca a los miembros de esta lista 
## como tales y, finalmente, marca a sus descendientes como disponibles.
func _on_EventNode_chosen(node: EventNode):
	print(RunData.rng.state)
#	RunData.save_rng_state()
#	RunData.save_game()
	await ScreenTransitions.fade_to_black()
	traveled_nodes.append(node)
	traveled_coords.append(node.coordinates)
	remove_availability()
	mark_traveled()
	make_descendants_available(node)
	for map_screen_node in get_tree().get_nodes_in_group("map_screen"):
		map_screen_node.hide()
	# Acceso al singleton para pasar el jugador al evento.
	var event_scene = node.instantiate_event_scene(RunData.player)
	get_parent().add_child(event_scene)
	ScreenTransitions.fade_from_black()
	await event_scene.finished
	await ScreenTransitions.fade_to_black()
	for map_screen_node in get_tree().get_nodes_in_group("map_screen"):
		map_screen_node.show()
	ScreenTransitions.fade_from_black()
	RunData.save_game()


#func _on_Event_finished():
#	for map_screen_node in get_tree().get_nodes_in_group("map_screen"):
#		map_screen_node.show()

## Conecta las señales que se van a utilizar de todos los nodos en node_matrix
func connect_to_node_signals(p_node_matrix):
	for i in range(p_node_matrix.size()):
		for j in range(p_node_matrix[i].size()):
			# Se asegura de no reconectar, solo útil si se planean reutilizar niveles en la misma partida.
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

## Marca los nodos descientes del nodo seleccionado como disponibles.
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
	await change_level(current_level)


func _on_NavigationButton_pressed():
	for i in node_matrix.size():
		for j in node_matrix[i].size():
			node_matrix[i][j].state = EventNode.State.AVAILABLE
