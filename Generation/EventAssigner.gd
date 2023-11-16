extends Resource
class_name EventAssigner

func get_event(_rng: RandomNumberGenerator, _node_matrix :Array = [], _node: EventNode = null) -> Event:
	return Event.new()
