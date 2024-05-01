extends Cost
class_name CoinCost

@export var coin_count_mod: CoinCountModifier

func can_pay(user: Player):
	return coin_count_mod.coin_count < user.get_coin_count()

func pay(user: Player):
	coin_count_mod.apply_to(user)

func get_description():
	return "Cost: " + coin_count_mod.get_description()
