extends Modifier
class_name BiasModifier

@export var facing: Coin.Facing
var base: Coin.Facing

func _init(p_facing: Coin.Facing = Coin.Facing.ANY):
	facing = p_facing
	
func apply_to(user: Player):
	base = user.bias
	user.bias = facing
	_finish()

func get_description(stats: CombatantStats = null) -> String:
	var desc = ""
	if facing == Coin.Facing.ANY:
		desc = "Allow coins to flip normally."
	else:
		desc = "Force coin flip results to "
		desc += "Heads." if facing == Coin.Facing.HEADS else "Tails."
	return desc

func undo_from(user: Player):
	user.bias = base
