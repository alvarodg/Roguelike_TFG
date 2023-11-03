extends MapGenerator
class_name GenerationParameters

# Generación basada en el método presentado por Basudev Patel en su entrada de blog
# "Random Paths in Gamedev Beatdown", con implementación y modificaciones propias.
# https://medium.com/@1basudevpatel/random-paths-in-gamedev-beatdown-a913a1d8c5e6

@export var rows: int = 4
@export var columns: int = 10
@export var base_position = Vector2.ZERO
@export var distance = Vector2(10,10)
@export var position_noise = Vector2.ZERO
@export var iterations = 10
@export var clamp_at: Array[int] = [0, -1]
@export var clamp_at_to: Array[Vector2] = [Vector2(-2,3), Vector2(4,3)]

var graph: EventNodeGraph
var node_matrix: = []
var rng: RandomNumberGenerator

func generate(p_rng: RandomNumberGenerator) -> Array:
	rng = p_rng
	graph = EventNodeGraph.new()
	node_matrix = new_2d_array(columns, rows)
	_generate_paths()
	_clamp_paths_to()
	_clamp_paths()
	_weld_paths()
	_store_data()
	return node_matrix

## Genera la matriz de nodos y conecta los nodos de la misma altura de izquierda a derecha, fila por fila
func _generate_paths():
	for i in range(columns):
		for j in range(rows):
			# Separa las columnas la distancia horizontal, las filas la vertical.
			var node_position = base_position + Vector2(distance.x * i, distance.y * j)
			var noise = Vector2(rng.randf_range(-position_noise.x, position_noise.x), rng.randf_range(-position_noise.y, position_noise.y))
			node_position += noise
			# Crea el nuevo nodo y le asigna la posición
			var node = graph.add_vertex()
			node.position = node_position
			# Guarda el nodo en una matriz representando su posición.
			node_matrix[i][j] = node
	# Enlaza todos los nodos de cada fila
	for i in range(rows):
		var last_vertex = -1
		for j in range(columns):
			var vertex = node_matrix[j][i].index
			# Si last_vertex no es -1, no estamos en el primer nodo de una fila. Podemos conectar.
			if last_vertex >=0:
				graph.add_edge(last_vertex, vertex)
			last_vertex = vertex

## Fusiona hasta dejar un único nodo en la columna
func _clamp_paths():
	for i in clamp_at:
		while node_matrix[i].size() >= 2:
			var row = rng.randi_range(0, node_matrix[i].size() - 2)
			_weld_neightbors(i, row)

## Fusiona hasta dejar el número indicado de nodos en la columna
func _clamp_paths_to():
	for v in clamp_at_to:
		while node_matrix[v.x].size() >= v.y+1:
			var row = rng.randi_range(0, node_matrix[v.x].size() - 2)
			_weld_neightbors(v.x, row)

## Fusiona aleatoriamente si puede en cualquier columna, hasta llegar a iteraciones
func _weld_paths():
	var i = 0
	while i < iterations and node_matrix.size() > 2:
		var column = rng.randi_range(0, columns-1)
		if node_matrix[column].size() >= 2:
			var row = rng.randi_range(0, node_matrix[column].size() - 2)
			_weld_neightbors(column, row)
			i += 1
			
## Fusiona un nodo concreto con el inmediatamente inferior, heredando sus conexiones
func _weld_neightbors(column, row):
	var node_to_weld = node_matrix[column][row]
	var node_to_remove = node_matrix[column][row+1]
	
	var average_position = 0.5 * (node_to_weld.position + node_to_remove.position)
	node_to_weld.position = average_position

	var descendants = graph.get_descendants(node_to_remove.index)
	var ascestors = graph.get_ancestors(node_to_remove.index)
	for d in descendants:
		graph.remove_edge(node_to_remove.index, d)
		graph.add_edge(node_to_weld.index, d)
	for a in ascestors:
		graph.remove_edge(a, node_to_remove.index)
		graph.add_edge(a, node_to_weld.index)
		
	graph.remove_vertex(node_to_remove.index)
	node_matrix[column].pop_at(row+1)

## Guarda datos en los propios nodos antes de pasarlos. Específicamente sus descendientes y 
## sus coordenadas en el array 2D.
func _store_data():
	for i in range(node_matrix.size()):
		for j in range(node_matrix[i].size()):
			node_matrix[i][j].coordinates = Vector2(i,j)
			var descendants = graph.get_descendants(node_matrix[i][j].index)
			for descendant_index in descendants:
				node_matrix[i][j].add_descendant(graph.get_value(descendant_index))

## Crea un array de dos dimensiones
func new_2d_array(width, height, value=0):
	var array = []
	for i in range(width):
		array.append([])
		for j in range(height):
			array[i].append(value)
	return array
