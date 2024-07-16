extends Restriction
## Tipo de restricción que limita los eventos que podrán aparecer 
## en cierta columna del mapa de nodos
class_name ColumnRestriction

## Índice de columna para el que se devolverá el evento
@export var column: int

## Comprueba si el nodo que se le ha pasado está en la columna restringida
func check(node_matrix: Array, node: EventNode) -> bool:
	var actual_column = column
	## Si tiene un índice negativo, cuenta de final a principio
	if actual_column < 0 and abs(actual_column) < node_matrix.size(): 
		actual_column = node_matrix.size() + actual_column
	return actual_column == node.coordinates.x
