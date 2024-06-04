extends Modifier
class_name CoinDropModifier

## Cantidad de monedas que caerán
@export var drop_count: int = 1
## Preferencia de cara, cruz o ninguna
@export var facing: Coin.Facing = Coin.Facing.ANY

func _init(p_drop_count: int = 1):
	drop_count = p_drop_count
	
func apply_to(user: Player):
	# Emite la señal global para indicar que van a caer monedas
	EventBus.about_to_drop_coins.emit()
	# Crea una lista de monedas disponibles
	var droppable: Array[Coin] = user.get_available_coins()
	var counter = drop_count
	# Mientras que queden monedas en la lista y no hayan caído suficientes
	while not droppable.is_empty() and counter > 0:
		# Filtra por la cara preferida
		var preferred_list = droppable.filter(func(c: Coin): return c.is_compatible(facing))
		var coin: Coin
		# Si quedan de la cara preferida, hace caer de estas, si no de cualquiera.
		if preferred_list.size() > 0:
			coin = preferred_list.pick_random()
		else:
			coin = droppable.pick_random()
		coin.set_dropped()
		droppable.erase(coin)
		counter -= 1
	_finish()
	
func get_description(_stats: CombatantStats = null) -> String:
	var plural = "s" if drop_count > 1 else ""
	var preference = ""
	if facing != Coin.Facing.ANY:
		preference = " (Prioritize %s)" % [Coin.get_facing_text(facing)]
	return "Drop %s random Coin%s%s." % [drop_count, plural, preference]
