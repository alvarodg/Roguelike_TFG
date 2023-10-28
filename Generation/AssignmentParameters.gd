extends Resource
class_name AssignmentParameters

@export var event_list: Array[Event]
@export var event_chances: Array[float]
@export var restrictions: Array[Vector2]

func ready():
	while event_list.size() > event_chances.size():
		event_chances.append(0.0)

func get_event(row) -> Event:
	# A mejorar, de momento solo deja indicar una columna en la que todos los eventos
	# tienen que ser iguales y después reparte aleatoriamente
	for restriction in restrictions:
		if restriction.x == row:
			return event_list[restriction.y]
	# Implementado a voleo, pero debería funcionar
	# Selecciona un evento de acuerdo con sus probabilidades
	var total_chance = 0.0
	for event_chance in event_chances:
		total_chance += event_chance
	var current_chance = 0.0
	var roll = randf_range(0,total_chance)
	for i in range(event_list.size()):
		current_chance += event_chances[i]
		if current_chance >= roll:
			return event_list[i]
	return event_list.front()
