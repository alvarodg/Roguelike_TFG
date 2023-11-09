extends Skill
class_name AttackSkill

func _init(p_data: AttackSkillData, p_user, p_target):
	super._init(p_data,p_user,p_target)
	
func use():
	for i in range(data.hits):
#		target.take_damage(data.damage)
		# TEMPORAL
		target.health -= data.damage
		var timer: Timer = Timer.new()
		timer.start(0.5)
		await timer.timeout
	user.energy -= data.cost
	finished.emit(true)
