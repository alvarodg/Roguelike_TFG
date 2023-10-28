extends Node2D

func _ready():
	test_graph()
	pass


func test_graph():
	var grafo = PositionGraph.new()
	for i in range(5):
		grafo.add_vertex(Vector2(i,i))
	assert(grafo.get_value(0) == Vector2(0,0))
	grafo.add_edge(0,1)
	assert(1 in grafo.get_neightbors(0))
	assert(0 in grafo.get_neightbors(1))
	grafo.remove_vertex(2)
	assert(1 in grafo.get_neightbors(0))
	assert(0 in grafo.get_neightbors(1))
	grafo.remove_vertex(1)
	assert(1 not in grafo.get_neightbors(0))
	assert(0 not in grafo.get_neightbors(1))
	grafo.add_edge(0,1)
	grafo.remove_edge(0,1)
	assert(1 not in grafo.get_neightbors(0))
	assert(0 not in grafo.get_neightbors(1))
	assert(grafo.get_value(0) == Vector2(0,0))
