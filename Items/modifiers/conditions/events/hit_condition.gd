extends EventCondition
class_name HitCondition

func connect_to(p_user):
	super.connect_to(p_user)
	p_user.stats.hit.connect(_check_met)

func get_description():
	var plural = "" if amount == 1 else " %d times" % amount
	return "user is hit%s" % plural
