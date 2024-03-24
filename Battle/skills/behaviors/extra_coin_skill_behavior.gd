extends SkillBehavior
class_name ExtraCoinSkillBehavior

@export var ephemeral_coins: int = 0
# TEMPORAL, usar lista para poder dar un facing a cada moneda
@export var facing: Coin.Facing = Coin.Facing.ANY


func use(user, _target, coins):
	for i in range(ephemeral_coins):
		var eph_coin = coins.front().get_ephemeral_copy()
		if facing == Coin.Facing.ANY:
			user.flip(eph_coin)
		else:
			eph_coin.heads = true if facing == Coin.Facing.HEADS else false
		user.add_coin(eph_coin)

func get_description(_stats: CombatantStats = null) -> String:
	var description: String = ""
	var facing_text: String = "(%s)" % [Coin.get_facing_text(facing)]
	if ephemeral_coins > 0:
		var plural = "" if ephemeral_coins == 1 else "s"
		if description != "": description += "\n"
		description += "%d Extra Coin%s %s" % [ephemeral_coins, plural, facing_text]
	return description
