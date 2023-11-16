extends Container

signal generation_complete(node_matrix)

@export var on = true
@export var map_generator: MapGenerator
@export var event_assigner: EventAssigner
var event_node_scene = preload("res://Events/event_node.tscn")

var node_matrix: Array
var rng: RandomNumberGenerator

func _ready():
	pass
	
func generate(rng_seed = 0):
	print(rng_seed)
	node_matrix = []
	if not on: return
	for child in get_children():
		child.queue_free()
	rng = RandomNumberGenerator.new()
	rng.seed = rng_seed
	node_matrix = map_generator.generate(rng)
	assign_nodes()
	emit_signal("generation_complete", node_matrix)


## Añade todos los nodos a la escena y les asigna eventos
func assign_nodes():
	for i in range(node_matrix.size()):
		for j in range(node_matrix[i].size()):
			# Añade el nodo a la escena
			var current_node = node_matrix[i][j]
			current_node.set_text(str(current_node.index))
			# Asigna un evento al nodo
			current_node.event = event_assigner.get_event(rng, node_matrix, current_node)
			add_child(current_node)
			

func new_2d_array(width, height, value=0):
	var array = []
	for i in range(width):
		array.append([])
		for j in range(height):
			array[i].append(value)
	return array

func node_matrix_index():
	var matrix = node_matrix.duplicate()
	for i in range(node_matrix.size()):
		for j in range(node_matrix[i].size()):
			matrix[i][j] = node_matrix[i][j].index
	return matrix
