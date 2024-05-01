extends SkillBehavior
class_name DropUsedCoinsSkillBehavior

func use(user, _target, coins):
	assert(user is Player)
	for coin in coins:
		coin.set_dropped()
		_finish()
		
func get_description(_stats: CombatantStats = null):
	return "Coins spent on this skill are considered to be dropped."
