extends Resource
class_name Collection

enum Operator {AND, OR}

func add(_element):
	pass

func remove(_element):
	pass

func size() -> int:
	return 0

func get_random(_rng: RandomNumberGenerator = RandomNumberGenerator.new(), _tags: Array = [], 
				_op: Operator = Operator.OR, _rarity_pick: Array[int] = [], _rarity_factor: float = 1.0):
	return null
	
func get_random_list(amount: int = 1, rng: RandomNumberGenerator = RandomNumberGenerator.new(),
		tags: Array = [], op: Collection.Operator = Collection.Operator.OR, 
		rarity_pick: Array[int] = [],  rarity_factor: float = 1) -> Array:
	# Duplica la colección para poder sacar elementos temporalmente.
	var collection: Collection = self.duplicate()
	# Se asegura de que la cantidad de elementos a seleccionar no supera el tamaño
	var picks: int = min(amount, collection.size())
	var chosen_list: Array = []
	for i in range(picks):
		# Llama a la función get_random(), sobreescrita por cada subclase
		var chosen_skill = collection.get_random(rng, tags, op, rarity_pick, rarity_factor)
		# Si se ha seleccionado una habilidad, la añade a la lista y la borra de
		# la colección temporal
		if chosen_skill != null:
			chosen_list.append(chosen_skill)
			collection.remove(chosen_skill)
	return chosen_list

func get_random_list_deterministic(amount: int = 1,
		tags: Array = [], op: Collection.Operator = Collection.Operator.OR, 
		rarity_pick: Array[int] = [],  rarity_factor: float = 1) -> Array:
	return get_random_list(amount, RunData.rng, tags, op, rarity_pick, rarity_factor)

func _choose_random_index_from(rarity_list: Array, rng: RandomNumberGenerator = RandomNumberGenerator.new(), 
								rarity_factor: float = 1):
	var chosen: int = 0
	var total_chance = 0.0
	for rarity in rarity_list:
		total_chance += 1.0/(1 + rarity * rarity_factor)
	var current_chance = 0.0
	var roll = rng.randf_range(0,total_chance)
	for i in range(rarity_list.size()):
		current_chance += 1.0/(1 + rarity_list[i] * rarity_factor)
		if current_chance >= roll:
			chosen = i
			break
	return chosen

func _get_random_from_list(list: Array[Variant], rng: RandomNumberGenerator = RandomNumberGenerator.new(),
 						   tags: Array[Variant] = [], op: Operator = Operator.OR, 
						   rarity_pick: Array[int] = [], rarity_factor: float = 1) -> Variant:
	var pickable: Array = list
	# Comprueba si la lista está vacía
	if list.size() == 0:
		return null
	# Comprueba si la clase de los objetos de la lista tiene las variables "tags" y "rarity"
	if not "tags" in list.front() or not "rarity" in list.front():
		return null
	if tags.size() > 0:
		# Si el operador es OR, filtra la lista seleccionando cada elemento
		# con alguna de sus tags en "tags".
		if op == Operator.OR:
			pickable = pickable.filter(
				func(x): return x.tags.any(
					func(y): return tags.has(y)))
		# Si el operador es AND, filtra la lista seleccionando cada elemento
		# con todas sus tags en "tags". 
		if op == Operator.AND:
			pickable = pickable.filter(
				func(x): return tags.all(
					func(y): return y in x.tags))
#			pickable = pickable.filter(
#				func(x): return x.tags.all(
#					func(x): return tags.has(x)))
	if rarity_pick.size() > 0:
		# Filtra la lista seleccionando cada elemento con rareza en "rarity_pick"
		pickable = pickable.filter(func(x): return rarity_pick.has(x.rarity))
		print(pickable)
	var rarity_list: Array[int] = []
	for item in pickable:
		rarity_list.append(item.rarity)
	var chosen: int = _choose_random_index_from(rarity_list, rng, rarity_factor)
	return pickable[chosen] if pickable.size() > 0 else null
