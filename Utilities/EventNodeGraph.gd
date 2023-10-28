extends Resource
class_name EventNodeGraph

var event_node_scene = preload("res://event_node.tscn")
var base_graph: MatrixGraphImplementation
var data: Array[EventNode]

func _init():
	base_graph = MatrixGraphImplementation.new(0, true)
	data = []

func add_edge(v1, v2, weight = 1):
	base_graph.add_edge(v1, v2, weight)

func remove_edge(v1,v2):
	base_graph.remove_edge(v1,v2)

func add_vertex() -> EventNode:
	var index = base_graph.add_vertex()
	var event_node = event_node_scene.instantiate()
	event_node.index = index
	data.append(event_node)
	return event_node

func remove_vertex(vertex):
	data.pop_at(vertex)
	base_graph.remove_vertex(vertex)
	for event_node in data:
		if event_node.index >= vertex:
			event_node.index -= 1

func get_value(vertex):
	return data[vertex]
	
func set_value(vertex, value):
	data[vertex] = value

func get_neightbors(vertex) -> Array:
	return base_graph.get_neightbors(vertex)
	
func get_ancestors(vertex) -> Array:
	return base_graph.get_ancestors(vertex)

func get_descendants(vertex) -> Array:
	return base_graph.get_descendants(vertex)

func get_neightbors_value(vertex):
	var values = []
	var neightbors = base_graph.get_neightbors(vertex)
	for n in neightbors:
		values.append(data[n])
	return values

func get_size():
	return base_graph.get_size()
	
func is_directed():
	return base_graph.is_directed()

func print_matrix():
	base_graph.print_matrix()

func print_data():
	print(data)
