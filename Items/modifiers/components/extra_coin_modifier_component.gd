extends Modifier
class_name ExtraCoinModifier

@export var coin_data_list: Array[CoinData]
# Posiblemente sustituir por arrays
@export var ephemeral: bool = true
@export var facing: Coin.Facing

func _init(p_coin_data_list: Array[CoinData] = []):
	coin_data_list = p_coin_data_list
	
func apply_to(user: Player):
	for coin_data in coin_data_list:
		var coin: Coin = coin_data.create_coin_instance(ephemeral)
		user.add_coin(coin.duplicate())
		match facing:
			Coin.Facing.ANY: user.flip(coin)
			Coin.Facing.HEADS: coin.heads = true
			Coin.Facing.TAILS: coin.heads = false

func get_description() -> String:
	var coin_type = "Ephemeral" if ephemeral else "Persistent"
	var plural = "" if coin_data_list.size() == 1 else "s"
	var facing_text = ""
	match facing:
		Coin.Facing.ANY: facing_text = "Flip"
		Coin.Facing.HEADS: facing_text = "Heads"
		Coin.Facing.TAILS: facing_text = "Tails"
	return "%+d %s Coin%s (%s)." % [coin_data_list.size(), coin_type, plural, facing_text]
