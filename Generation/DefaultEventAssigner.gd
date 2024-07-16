extends EventAssigner
## Implementación de la asignación de eventos que permite restringir
## el contenido de ciertos nodos según criterios
## y repartir el resto de eventos aleatoriamente
class_name RestrictionEventAssigner

## Lista de eventos a asignar
@export var event_list: Array[Event]
## Lista de pesos de probabilidades, asociados a los eventos (mayor = más común)
@export var event_chances: Array[float]
## Lista de restricciones que se comprobarán antes de dar un evento aleatorio
@export var restrictions: Array[Restriction]
## Generador de números aleatorios
var rng: RandomNumberGenerator

## Comprobando un nodo y la matriz en la que se encuentra, devuelve un evento
## a partir de las reglas definidas.
func get_event(p_rng: RandomNumberGenerator, node_matrix :Array = [], node: EventNode = null) -> Event:
	rng = p_rng
	# Si no se le pasa un nodo, devuelve un evento vacío
	if not node is EventNode: return Event.new()
	# Comprueba primero si al nodo se aplica alguna de las restricciones
	# (se aplicará la primera que se encuentre)
	for restriction in restrictions:
		# Si se aplica una restricción, devuelve su evento asociado
		if restriction.check(node_matrix, node):
			return restriction.event
	# Selecciona un evento de acuerdo con sus probabilidades
	var total_chance = 0.0
	# Suma los pesos de probabilidad de los eventos
	for event_chance in event_chances:
		total_chance += event_chance
	var current_chance = 0.0
	# Obtiene un valor aleatorio entre 0 y el peso total
	var roll = rng.randf_range(0,total_chance)
	# Devuelve el evento en cuyo rango de probabilidad 
	# se encuentre el valor aleatorio
	for i in range(event_list.size()):
		current_chance += event_chances[i]
		if current_chance >= roll:
			return event_list[i]
	# Si por cualquier motivo no se ha devuelto un evento, 
	# devuelve el del frente de la lista
	return event_list.front()

func to_save_dict() -> Dictionary:
	var event_path_list = []
	for event in event_list:
		event_path_list.append(event.resource_path)
#	var str_restrictions = []
#	for res in restrictions:
#		str_restrictions.append(var_to_str(res))
	var dict = {
		"event_list" : event_path_list,
		"event_chances" : event_chances,
		"restrictions" : restrictions
	}
	return dict

func load_dict(dict: Dictionary):
	for path in dict["event_list"]:
		event_list.append(load(path))
	event_chances = dict["event_chances"]
#	for res in dict["restrictions"]:
#		restrictions.append(res)
	restrictions = dict["restrictions"]

func save_keys():
	return ["event_list", "event_chances", "restrictions"]
