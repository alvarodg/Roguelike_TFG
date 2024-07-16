extends Resource
class_name Restriction

## Evento asociado a la restricción, que se devolverá si se cumple
@export var event: Event

## Comprueba si se aplica la restricción. Sobreescribir en subclases.
func check(_node_matrix: Array, _node: EventNode) -> bool:
	return false

## Comprueba si se aplica la restricción y devuelve el evento si es así.
func check_get(node_matrix: Array, node: EventNode) -> Event:
	return get_event() if check(node_matrix, node) else null

## Devuelve su evento asociado
func get_event() -> Event:
	return event
