extends SkillBehavior
class_name RemoveCoinSkillBehavior

@export var magnitude: int = 0
@export var to_self: bool = true
@export var remove_all_used: bool = false

func use(user, target, coins):
	if to_self:
		assert(user is Player)
		if remove_all_used:
			for c in coins:
				user.coins.erase(c)
				c.queue_free()
		for i in range(magnitude):
			var c = user.coins.pick_random()
			user.coins.erase(c)
			c.queue_free()
	else:
		# Posiblemente cambiar la implementación para que prioritice monedas disponibles si
		# se fuera a utilizar esta parte del comportamiento. Probablemente no se va a usar.
		assert(target is Player)
		for i in range(magnitude):
			var c = target.coins.pick_random()
			target.coins.erase(c)
			c.queue_free()
	_finish()
	
func get_description(stats: CombatantStats = null):
	var desc: String = ""
	var plural: String = "" if magnitude == 1 else "s"
	if to_self:
		if remove_all_used:
			desc += "Coins used on this skill are lost for the rest of battle."
		if magnitude > 0:
			desc += "Lose %s coin%s" % [magnitude, plural]
	else:
		desc += "Target loses %s coin%s" % [magnitude, plural]
	return desc
