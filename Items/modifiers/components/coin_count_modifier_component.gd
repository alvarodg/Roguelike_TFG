extends Modifier
class_name CoinCountModifier

@export var coin_count: int

func _init(p_coin_count: int = 0):
	coin_count = p_coin_count
	
func apply_to(user):
	assert(user.stats is PlayerStats)
	user.stats.coin_count += coin_count

func get_description() -> String:
	var plural = "s" if coin_count > 1 else ""
	return "%+d Coin%s." % [coin_count, plural]
