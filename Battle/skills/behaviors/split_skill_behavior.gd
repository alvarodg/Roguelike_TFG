extends SkillBehavior
class_name SplitSkillBehavior

@export var heads_behaviors: Array[SkillBehavior]
@export var tails_behaviors: Array[SkillBehavior]

func use(user, target, coins):
	# Solo comprueba la primera moneda, indicar o no utilizar con ranura de múltiples monedas.
	if coins.front().heads:
		for behavior in heads_behaviors:
			behavior.use(user,target,coins)
	else:
		for behavior in tails_behaviors:
			behavior.use(user,target,coins)

func get_description() -> String:
	var heads_description = ""
	var tails_description = ""
	for behavior in heads_behaviors:
		if heads_description != "": heads_description += "\n"
		heads_description += behavior.get_description()
	for behavior in tails_behaviors:
		if tails_description != "": tails_description += "\n"
		tails_description += behavior.get_description()
	var description = "Heads: %s\nTails: %s" % [heads_description, tails_description]
	return description
