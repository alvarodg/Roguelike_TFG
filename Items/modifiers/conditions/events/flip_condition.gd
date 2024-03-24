extends EventCondition
class_name FlipCondition

@export var facing: Coin.Facing

func connect_to(p_user: Player):
	super.connect_to(p_user)
	p_user.coin_flipped.connect(_check_met)

func _check_met(coin = null):
	if facing == Coin.Facing.ANY:
		super._check_met()
	elif facing == Coin.Facing.HEADS and coin.heads:
		super._check_met()
	elif facing == Coin.Facing.TAILS and not coin.heads:
		super._check_met()
	
func get_description():
	var desc: String = ""
	var plural: String = ""
	match facing:
		Coin.Facing.ANY: desc = "a coin is flipped" if amount <= 1 else "coins are flipped"
		Coin.Facing.HEADS: desc = "a coin flips Heads" if amount <=1 else "coins flip Heads"
		Coin.Facing.TAILS: desc = "a coin flips Tails" if amount <=1 else "coins flip Tails"
	if amount > 1:
		desc += " %d times" % [amount]
	return desc
