extends EventAssigner
class_name DefaultEventAssigner

@export var event_list: Array[Event]
@export var event_chances: Array[float]
@export var restrictions: Array[Vector2]
var rng: RandomNumberGenerator

#func _init(p_event_list: Array[Event] = [], p_event_chances: Array[float] = [], p_restrictions: Array[Vector2] = []):
#	event_list = p_event_list
#	event_chances = p_event_chances
#	restrictions = p_restrictions
#	SAVE_KEYS = ["event_list", "event_chances", "restrictions"]
#	while event_list.size() > event_chances.size():
#		event_chances.append(0.0)

func get_event(p_rng: RandomNumberGenerator, node_matrix :Array = [], node: EventNode = null) -> Event:
	rng = p_rng
	if not node is Node: return Event.new()
	# Asignación básica, deja indicar columnas en las que todos los eventos
	# tienen que ser iguales y después reparte aleatoriamente
	for restriction in restrictions:
		if restriction.x < 0 and abs(restriction.x) < node_matrix.size(): 
			restriction.x = node_matrix.size() + restriction.x
		if restriction.x == node.coordinates.x:
			return event_list[restriction.y]
	# Selecciona un evento de acuerdo con sus probabilidades
	var total_chance = 0.0
	for event_chance in event_chances:
		total_chance += event_chance
	var current_chance = 0.0
	var roll = rng.randf_range(0,total_chance)
	for i in range(event_list.size()):
		current_chance += event_chances[i]
		if current_chance >= roll:
			return event_list[i]
	return event_list.front()

func to_save_dict() -> Dictionary:
	var event_path_list = []
	for event in event_list:
		event_path_list.append(event.resource_path)
	var str_restrictions = []
	for res in restrictions:
		str_restrictions.append(var_to_str(res))
	var dict = {
		"event_list" : event_path_list,
		"event_chances" : event_chances,
		"restrictions" : str_restrictions
	}
	return dict

func load_dict(dict: Dictionary):
	for path in dict["event_list"]:
		event_list.append(load(path))
	event_chances = dict["event_chances"]
	for res in dict["restrictions"]:
		restrictions.append(str_to_var(res))

func save_keys():
	return ["event_list", "event_chances", "restrictions"]
