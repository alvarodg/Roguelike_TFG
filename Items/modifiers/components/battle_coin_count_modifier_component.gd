extends Modifier
class_name BattleCoinCountModifier

@export var coin_count: int

func _init(p_coin_count: int = 0):
	coin_count = p_coin_count
	
func apply_to(user: Player):
	user.stats.battle_coin_count += coin_count
	_finish()

func undo_from(user: Player):
	user.stats.battle_coin_count -= coin_count


func get_description(_stats: CombatantStats = null) -> String:
	var plural = "s" if coin_count > 1 else ""
	return "%+d Coin%s (for the battle)." % [coin_count, plural]
