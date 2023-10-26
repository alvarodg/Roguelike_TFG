extends Node2D

@export var on = true
@export var parameters: GenerationParameters
var event_node = preload("res://event_node.tscn")

var graph: Graph
var node_matrix: Array
var vertex_matrix: Array
var to_draw_from: Array[Vector2]
var to_draw_to: Array[Vector2]

func _ready():
	if not on: return
	randomize()
	graph = Graph.new()
	node_matrix = new_2d_array(parameters.columns, parameters.rows)
	vertex_matrix = new_2d_array(parameters.columns, parameters.rows)
	generate_paths()
	clamp_paths_to()
	clamp_paths()
	weld_paths()
	display_nodes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	for i in range(to_draw_from.size()):
		draw_line(to_draw_from[i], to_draw_to[i], Color.WHITE, 2.0)

func generate_paths():
	for i in range(parameters.columns):
		for j in range(parameters.rows):
			# Separa las columnas la distancia horizontal, las filas la vertical.
			var node_position = parameters.base_position + Vector2(parameters.distance.x * i, parameters.distance.y * j)
			# Introduce el nuevo nodo en el grafo (posicion actualmente)
			var vertex = graph.add_vertex(node_position)
			# Guarda el nodo y su índice en matrices representando su posición.
			node_matrix[i][j] = graph.get_value(vertex)
			vertex_matrix[i][j] = vertex
	# Enlaza todos los nodos de cada fila
	for i in range(parameters.rows):
		var last_vertex = -1
		for j in range(parameters.columns):
			var vertex = vertex_matrix[j][i]
			# Si last_vertex no es -1, no estamos en el primer nodo de una fila. Podemos conectar.
			if last_vertex >=0:
				graph.add_edge(last_vertex, vertex)
			last_vertex = vertex
			

# Fusiona hasta dejar un único nodo en la columna
func clamp_paths():
	for i in parameters.clamp_at:
		while node_matrix[i].size() >= 2:
			var row = randi_range(0, node_matrix[i].size() - 2)
			weld_neightbors(i, row)

# Fusiona hasta dejar el número indicado de nodos en la columna
func clamp_paths_to():
	for v in parameters.clamp_at_to:
		while node_matrix[v.x].size() >= v.y+1:
			var row = randi_range(0, node_matrix[v.x].size() - 2)
			weld_neightbors(v.x, row)

# Fusiona aleatoriamente si puede en cualquier columna, hasta llegar a iteraciones
func weld_paths():
	var i = 0
	while i < parameters.iterations and vertex_matrix.size() > 2:
		var column = randi_range(0, parameters.columns-1)
		if node_matrix[column].size() >= 2:
			var row = randi_range(0, node_matrix[column].size() - 2)
			weld_neightbors(column, row)
			i += 1

func weld_neightbors(column, row):
#	Ahora mismo no utiliza la posicion
	var node_to_weld = node_matrix[column][row]
	var node_to_remove = node_matrix[column][row+1]
	var vertex_to_weld = vertex_matrix[column][row]
	var vertex_to_remove = vertex_matrix[column][row+1]
	
	node_matrix[column].pop_at(row+1)
	vertex_matrix[column].pop_at(row+1)
	
	var average_position = 0.5 * (node_to_weld + node_to_remove)
	graph.set_value(vertex_to_weld, average_position)
	node_matrix[column][row] = average_position
	
	var neightbors = graph.get_neightbors(vertex_to_remove)
	for n in neightbors:
		graph.remove_edge(n, vertex_to_remove)
		graph.add_edge(n, vertex_to_weld)
	graph.remove_vertex(vertex_to_remove)
	# Actualiza los indices de los vertices
	for i in range(vertex_matrix.size()):
			for j in range(vertex_matrix[i].size()):
				if vertex_matrix[i][j] > vertex_to_remove:
					vertex_matrix[i][j] -= 1

func display_nodes():
	for i in range(node_matrix.size()):
		for j in range(node_matrix[i].size()):
			# Crea un nuevo nodo de evento y lo coloca en la posición guardada en el grafo
			var new_node = event_node.instantiate()
			add_child(new_node)
			var vertex = vertex_matrix[i][j]
			var node_position = node_matrix[i][j]
			new_node.position = node_position
			new_node.set_text(str(vertex))
			# Guarda coordenadas para dibujar líneas a sus vecinos.
			# TEMPORAL (Para visualización del algoritmo)
			var neightbors = graph.get_neightbors(vertex)
			for n in neightbors:
				to_draw_from.append(graph.get_value(n))
				to_draw_to.append(node_position)


func new_2d_array(width, height, value=0):
	var array = []
	for i in range(width):
		array.append([])
		for j in range(height):
			array[i].append(value)
	return array
