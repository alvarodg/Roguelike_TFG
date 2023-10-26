extends Node
class_name Graph

var graph: MatrixGraph
var data: Array

func _init():
	graph = MatrixGraph.new(0, true)
	data = []

func add_edge(v1, v2, weight = 1):
	graph.add_edge(v1,v2, weight)

func remove_edge(v1,v2):
	graph.remove_edge(v1,v2)

func add_vertex(value) -> int:
	data.append(value)
	return graph.add_vertex()

func remove_vertex(vertex):
	data.pop_at(vertex)
	graph.remove_vertex(vertex)

func get_value(vertex):
	return data[vertex]
	
func set_value(vertex, value):
	data[vertex] = value

func get_neightbors(vertex) -> Array:
	return graph.get_neightbors(vertex)
	
func get_ancestors(vertex) -> Array:
	return graph.get_ancestors(vertex)

func get_descendants(vertex) -> Array:
	return graph.get_descendants(vertex)

func get_neightbors_value(vertex):
	var values = []
	var neightbors = graph.get_neightbors(vertex)
	for n in neightbors:
		values.append(data[n])
	return values

func get_size():
	return graph.get_size()
	
func is_directed():
	return graph.is_directed()

func print_matrix():
	graph.print_matrix()

func print_data():
	print(data)
