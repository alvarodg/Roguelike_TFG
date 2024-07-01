extends Restriction
class_name ColumnRestriction

@export var column: int

func check(node_matrix: Array, node: EventNode) -> bool:
	var actual_column = column
	if actual_column < 0 and abs(actual_column) < node_matrix.size(): 
		actual_column = node_matrix.size() + actual_column
	return actual_column == node.coordinates.x
