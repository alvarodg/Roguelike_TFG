extends Modifier
class_name BiasModifier

@export var facing: Coin.Facing
@export var count: int = 1
var base: Array[Coin.Facing]

func _init(p_facing: Coin.Facing = Coin.Facing.ANY):
	facing = p_facing
	
func apply_to(user: Player):
	base = user.bias_list.duplicate()
	user.add_bias(facing, count)
	_finish()

func get_description(stats: CombatantStats = null) -> String:
	var desc = ""
	if facing != Coin.Facing.ANY:
		desc = "Force %s coin flip results to %s" % [count, Coin.get_facing_text(facing)]
	return desc

func undo_from(user: Player):
	user.bias_list = base.duplicate()
