extends SkillBehavior
class_name ShieldSkillBehavior

@export var shield: int = 0

func use(user, _target, _coins):
	user.stats.shield += shield

func get_description():
	return "%s Shield" % [shield]
