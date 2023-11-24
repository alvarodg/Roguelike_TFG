extends SkillBehavior
class_name DamageSkillBehavior


@export var damage = 0
@export var to_self: bool = false

func use(user, target, _coins):
	if to_self:
		user.stats.take_damage(damage)
	else:
		target.stats.take_damage(damage)

func get_description() -> String:
	var description: String = ""
	if to_self:
		description = "%s Damage to self." % [damage]
	else:
		description = "%s Damage to target." % [damage]
	return description
