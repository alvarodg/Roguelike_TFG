extends Modifier
class_name CoinDropModifier

@export var drop_count: int

func _init(p_drop_count: int = 0):
	drop_count = p_drop_count
	
func apply_to(user: Player):
	assert(user is Player)
	EventBus.about_to_drop_coins.emit()
	var droppable: Array[Coin] = user.get_available_coins()
	var counter = drop_count
	while not droppable.is_empty() and counter > 0:
		var coin: Coin = droppable.pick_random()
		coin.set_dropped()
		droppable.erase(coin)
		counter -= 1
#	coin.set_spent()

func get_description(_stats: CombatantStats = null) -> String:
	var plural = "s" if drop_count > 1 else ""
	return "Drop %s random Coin%s." % [drop_count, plural]
