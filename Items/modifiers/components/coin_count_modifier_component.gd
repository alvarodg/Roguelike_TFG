extends Modifier
class_name CoinCountModifier

@export var coin_count: int

func _init(p_coin_count: int = 0):
	coin_count = p_coin_count
	
func apply_to(user: Player):
	user.stats.coin_count += coin_count
	_finish()

func undo_from(user: Player):
	print(user.stats.coin_count)
	print(coin_count)
	user.stats.coin_count -= coin_count
	print(user.stats.coin_count)

func get_description(_stats: CombatantStats = null) -> String:
	var plural = "s" if coin_count > 1 else ""
	return "%+d Coin%s." % [coin_count, plural]
