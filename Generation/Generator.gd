extends Container

@export var on = true
@export var parameters: GenerationParameters
@export var assignment: AssignmentParameters
var event_node_scene = preload("res://Events/event_node.tscn")

var graph: EventNodeGraph
var node_matrix: Array
var to_draw_from: Array[Vector2]
var to_draw_to: Array[Vector2]

func _ready():
	if not on: return
	randomize()
	graph = EventNodeGraph.new()
	node_matrix = new_2d_array(parameters.columns, parameters.rows)
	generate_paths()
	clamp_paths_to()
	clamp_paths()
	weld_paths()
	assign_nodes()
	store_relationships()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Genera la matriz de nodos y conecta los nodos de la misma altura de izquierda a derecha, fila por fila
func generate_paths():
	for i in range(parameters.columns):
		for j in range(parameters.rows):
			# Separa las columnas la distancia horizontal, las filas la vertical.
			var node_position = parameters.base_position + Vector2(parameters.distance.x * i, parameters.distance.y * j)
			# Crea el nuevo nodo y le asigna la posición
			var node = graph.add_vertex()
			node.position = node_position
			# Guarda el nodo en una matriz representando su posición.
			node_matrix[i][j] = node
	# Enlaza todos los nodos de cada fila
	for i in range(parameters.rows):
		var last_vertex = -1
		for j in range(parameters.columns):
			var vertex = node_matrix[j][i].index
			# Si last_vertex no es -1, no estamos en el primer nodo de una fila. Podemos conectar.
			if last_vertex >=0:
				graph.add_edge(last_vertex, vertex)
			last_vertex = vertex

## Fusiona hasta dejar un único nodo en la columna
func clamp_paths():
	for i in parameters.clamp_at:
		while node_matrix[i].size() >= 2:
			var row = randi_range(0, node_matrix[i].size() - 2)
			weld_neightbors(i, row)

## Fusiona hasta dejar el número indicado de nodos en la columna
func clamp_paths_to():
	for v in parameters.clamp_at_to:
		while node_matrix[v.x].size() >= v.y+1:
			var row = randi_range(0, node_matrix[v.x].size() - 2)
			weld_neightbors(v.x, row)

## Fusiona aleatoriamente si puede en cualquier columna, hasta llegar a iteraciones
func weld_paths():
	var i = 0
	while i < parameters.iterations and node_matrix.size() > 2:
		var column = randi_range(0, parameters.columns-1)
		if node_matrix[column].size() >= 2:
			var row = randi_range(0, node_matrix[column].size() - 2)
			weld_neightbors(column, row)
			i += 1
			
## Fusiona un nodo concreto con el inmediatamente inferior, heredando sus conexiones
func weld_neightbors(column, row):
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

## Añade todos los nodos a la escena
func assign_nodes():
	for i in range(node_matrix.size()):
		for j in range(node_matrix[i].size()):
			# Añade el nodo a la escena
			var current_node = node_matrix[i][j]
			current_node.set_text(str(current_node.index))
			# Asigna un evento al nodo
			current_node.event = assignment.get_event(i)
			add_child(current_node)
			

## Guarda los descendientes en los propios nodos, para evitar necesitar todo el grafo localmente
func store_relationships():
	for event_node in get_children():
		if event_node is EventNode:
			var descendants = graph.get_descendants(event_node.index)
			for descendant_index in descendants:
				event_node.add_descendant(graph.get_value(descendant_index))

func new_2d_array(width, height, value=0):
	var array = []
	for i in range(width):
		array.append([])
		for j in range(height):
			array[i].append(value)
	return array

func print_node_matrix_index():
	var matrix = node_matrix
	for i in range(node_matrix.size()):
		for j in range(node_matrix[i].size()):
			matrix[i][j] = node_matrix[i][j].index
	print(matrix)
