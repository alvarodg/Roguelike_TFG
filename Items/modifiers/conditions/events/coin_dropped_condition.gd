extends EventCondition
class_name CoinDroppedCondition

@export var facing: Coin.Facing

func connect_to(p_user: Player):
	super.connect_to(p_user)
	p_user.coin_dropped.connect(_check_met)

func _check_met(coin = null):
	if facing == Coin.Facing.ANY:
		super._check_met()
	elif facing == Coin.Facing.HEADS and coin.heads:
		super._check_met()
	elif facing == Coin.Facing.TAILS and not coin.heads:
		super._check_met()
	
func get_description():
	return _generate_description()

func _generate_description():
	var desc: String = ""
	match facing:
		Coin.Facing.ANY: desc = "a coin is dropped" if amount <= 1 else "coins are dropped"
		Coin.Facing.HEADS: desc = "a Heads coin is dropped" if amount <=1 else "Heads coins are dropped"
		Coin.Facing.TAILS: desc = "a Tails coin is dropped" if amount <=1 else "Tails coins are dropped"
	return desc + super._generate_description()
