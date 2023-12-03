extends EventCondition
class_name HitCondition

func connect_to(p_user):
	super.connect_to(p_user)
	p_user.stats.hit.connect(_on_met)

func get_description():
	return "user is hit"
