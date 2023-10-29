extends Control

var node_matrix = []
var traveled_nodes: Array[EventNode] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


## Al recibir la señal generation_complete de Generator, guarda los nodos generados,
## marca la primera tanda como disponible y se conecta a sus señales.
func _on_Generator_generation_complete(node_matrix):
	self.node_matrix = node_matrix
	for node in node_matrix[0]:
		node.state = EventNode.State.AVAILABLE
	connect_to_node_signals(node_matrix)

## Cuando se recibe la señal node_chosen de EventNode deja a todos los nodos sin disponibilidad, 
## añade el nodo que la mandó a la lista de atravesados y marca a los miembros de esta lista 
## como tales y finalmente marca a sus descendientes como disponibles.
func _on_EventNode_chosen(node: EventNode):
	traveled_nodes.append(node)
	remove_availability()
	mark_traveled()
	make_descendants_available(node)

## Conecta las señales que se van a utilizar de todos los nodos en node_matrix
func connect_to_node_signals(node_matrix):
	for i in range(node_matrix.size()):
		for j in range(node_matrix[i].size()):
			node_matrix[i][j].connect("node_chosen", _on_EventNode_chosen)

func mark_traveled():
	for node in traveled_nodes:
		node.state = EventNode.State.TRAVELED

func remove_availability():
	for i in range(node_matrix.size()):
		for j in range(node_matrix[i].size()):
			node_matrix[i][j].state = EventNode.State.UNAVAILABLE

func make_descendants_available(node):
	for descendant in node.descendants:
		descendant.state = EventNode.State.AVAILABLE
