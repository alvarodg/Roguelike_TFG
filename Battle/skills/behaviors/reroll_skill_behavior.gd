extends SkillBehavior
class_name RerollSkillBehavior

@export var rerolls: int = 0
# ¿Usar lista para poder dar un facing a cada moneda?
@export var facing: int = 0

func use(user, _target, coins):
	var iter = 0
	while iter < rerolls and iter < coins.size():
		var coin = coins[iter]
		coin.set_available()
		# Tira la moneda si no se indica cara o cruz, si no se lo asigna.
		if facing == 0:
			coin.flip(user.stats.base_luck)
		else:
			coin.heads = true if facing == 1 else false
		iter += 1

func get_description() -> String:
	var description: String = ""
	var facing_text: String
	match facing:
		0: facing_text = "(Flip)"
		1: facing_text = "(Heads)"
		2: facing_text = "(Tails)"
	if rerolls > 0:
		var plural = "" if rerolls == 1 else "s"
		if description != "": description += "\n"
		description += "%d Reroll%s %s" % [rerolls, plural, facing_text]
	return description
