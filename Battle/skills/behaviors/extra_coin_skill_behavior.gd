extends SkillBehavior
class_name ExtraCoinSkillBehavior

@export var ephemeral_coins: int = 0
# TEMPORAL, usar lista para poder dar un facing a cada moneda
@export var facing: int = 0

func use(user, _target, coins):
	for i in range(ephemeral_coins):
		var eph_coin = coins.front().get_ephemeral_copy()
		if facing == 0:
			user.flip(eph_coin)
		else:
			eph_coin.heads = true if facing == 1 else false
		user.add_coin(eph_coin)

func get_description() -> String:
	var description: String = ""
	var facing_text: String
	match facing:
		0: facing_text = "(Flip)"
		1: facing_text = "(Heads)"
		2: facing_text = "(Tails)"
	if ephemeral_coins > 0:
		var plural = "" if ephemeral_coins == 1 else "s"
		if description != "": description += "\n"
		description += "%d Extra Coin%s %s" % [ephemeral_coins, plural, facing_text]
	return description
