extends EventCondition
class_name HitCondition

func connect_to(user):
	user.stats.hit.connect(_on_met)
