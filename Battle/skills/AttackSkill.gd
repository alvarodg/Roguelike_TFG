extends Skill
class_name AttackSkill

func _init(p_data: AttackSkillData, p_user, p_target):
	super._init(p_data,p_user,p_target)
	
func use():
	for i in range(data.hits):
		# TEMPORAL. Cambiar herencia de Skill a Node2D o Control? Crear objeto para cada golpe?
		print("HIT! "+str(data.damage)+" Damage")
		target.stats.take_damage(data.damage)
	finished.emit(true)
