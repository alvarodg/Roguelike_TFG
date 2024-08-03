extends Resource
class_name EventAssigner

var SAVE_KEYS = []

## Devuelve un evento a partir del nodo al que se quiere asignar y la lista
## anidada de eventos en la que se encuentra.
## _nested_node_list debe ser de tipo Array[Array[EventNode]]
func get_event(_rng: RandomNumberGenerator, _nested_node_list :Array = [],
			   _node: EventNode = null) -> Event:
	return Event.new()

func save_keys() -> Array:
	return []
