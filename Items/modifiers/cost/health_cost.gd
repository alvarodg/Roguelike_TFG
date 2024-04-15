extends Cost
class_name HealthCost

@export var health_mod: HealthModifier

func can_pay(user: Player):
	if health_mod.action == StatModifier.Action.ADD:
		return user.stats.health > -health_mod.magnitude
	else:
		return true

func pay(user: Player):
	health_mod.apply_to(user)

func get_description():
	return "Cost: " + health_mod.get_description()
