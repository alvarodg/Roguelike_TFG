extends Modifier
class_name ExtraCoinModifier

@export var coin_data_list: Array[CoinData]
# Posiblemente sustituir por arrays
@export var ephemeral: bool = true
@export var facing: int = 0

func _init(p_coin_data_list: Array[CoinData] = []):
	coin_data_list = p_coin_data_list
	
func apply_to(user: Player):
	for coin_data in coin_data_list:
		var coin: Coin = coin_data.create_coin_instance(ephemeral)
		user.add_coin(coin)
		match facing:
			0: user.flip(coin)
			1: coin.heads = true
			2: coin.heads = false

func get_description() -> String:
	var coin_type = "Ephemeral" if ephemeral else "Persistent"
	var plural = "" if coin_data_list.size() == 1 else "s"
	var facing_text = ""
	match facing:
		0: facing_text = "Flip"
		1: facing_text = "Heads"
		2: facing_text = "Tails"
	return "%+d %s Coin%s (%s)." % [coin_data_list.size(), coin_type, plural, facing_text]
