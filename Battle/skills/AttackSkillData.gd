extends CoinSkillData
class_name AttackSkillData

# Datos para dañar al enemigo.
@export var damage: int = 0
@export var hits: int = 1


func _init():
	pass

func get_description() -> String:
	var description: String = ""
	# Descripción de daño
	if damage > 0:
		description += str(damage)
		if hits > 1:
			description += " x "+str(hits)
		description += " Damage"
	var super_description = super.get_description()
	if super_description != "":
		description+="\n"
	return description+super_description

func create_skill(user, target, coins) -> Skill:
	return AttackSkill.new(self, user, target, coins)
