extends Resource
class_name MatrixGraph

var size: int : get = get_size
var adj_matrix
var directed: bool : get = is_directed

func _init(size = 0, directed = false):
	adj_matrix = []
	for i in range(size):
		var v = []
		v.resize(size)
		v.fill(0)
		adj_matrix.append(v)
	self.size = size
	self.directed = directed
	
func add_edge(v1, v2, weight = 1):
	self.adj_matrix[v1][v2] = weight
	if not directed:
		self.adj_matrix[v2][v1] = weight

func remove_edge(v1,v2):
	if adj_matrix[v1][v2] == 0:
		return
	adj_matrix[v1][v2] = 0
	if not directed:
		adj_matrix[v2][v1] = 0

func add_vertex() -> int:
	for i in range(size):
		adj_matrix[i].append(0)
	size += 1
	var v = []
	v.resize(size)
	v.fill(0)
	adj_matrix.append(v)
	return size-1

func remove_vertex(vertex):
	for i in range(size):
		adj_matrix[i].pop_at(vertex)
	size -= 1
	adj_matrix.pop_at(vertex)

func get_neightbors(vertex) -> Array:
	var neightbors = get_ancestors(vertex) + get_descendants(vertex)
	var unique = []
	for n in neightbors:
		if not unique.has(n):
			unique.append(n)
	return unique

func get_ancestors(vertex) -> Array:
	var ancestors: Array = []
	for i in range(size):
		if adj_matrix[i][vertex]!= 0:
			ancestors.append(i)
	return ancestors

func get_descendants(vertex) -> Array:
	var descendants: Array = []
	for i in range(size):
		if adj_matrix[vertex][i]!= 0:
			descendants.append(i)
	return descendants

func get_size():
	return size
	
func is_directed():
	return directed

func print_matrix():
	for i in range(size):
		print(adj_matrix[i])
