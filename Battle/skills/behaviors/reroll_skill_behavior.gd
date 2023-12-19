extends SkillBehavior
class_name RerollSkillBehavior

@export var rerolls: int = 0
# ¿Usar lista para poder dar un facing a cada moneda?
@export var facing: Coin.Facing = Coin.Facing.ANY

func use(user, _target, coins):
	assert(user is Player)
	var iter = 0
	while iter < rerolls and iter < coins.size():
		var coin = coins[iter]
		coin.set_available()
		# Tira la moneda si no se indica cara o cruz, si no se lo asigna.
		if facing == Coin.Facing.ANY:
			user.flip(coin)
		else:
			coin.heads = true if facing == Coin.Facing.HEADS else false
		iter += 1

func get_description(combatant: Combatant = null) -> String:
	var description: String = ""
	var facing_text: String = "(%s)" % Coin.get_facing_text(facing)
	if rerolls > 0:
		var plural = "" if rerolls == 1 else "s"
		if description != "": description += "\n"
		description += "%d Reroll%s %s" % [rerolls, plural, facing_text]
	return description
