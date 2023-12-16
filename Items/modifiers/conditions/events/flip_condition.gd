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
	match facing:
		Coin.Facing.ANY: return "Coin is flipped"
		Coin.Facing.HEADS: return "Coin flips Heads"
		Coin.Facing.TAILS: return "Coin flips Tails"
