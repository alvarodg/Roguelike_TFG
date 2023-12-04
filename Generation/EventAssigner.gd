extends Resource
class_name EventAssigner

var SAVE_KEYS = []

func get_event(_rng: RandomNumberGenerator, _node_matrix :Array = [], _node: EventNode = null) -> Event:
	return Event.new()

func save_keys() -> Array:
	return []
