extends Resource
## Clase posiblemente innecesaria, podría usar Skill e ignorar los costes (o usarlos para dejar que
## el jugador afecte las habilidades del enemigo?). TEMPORAL?

#class_name EnemySkill

var data: EnemySkillData
var user
var target
var coins

func _init(p_data = null, p_user = null, p_target = null, p_coins = []):
	data = p_data
	user = p_user
	target = p_target
	coins = p_coins

func use():
	for behavior in data.behaviors:
		behavior.use(user, target, coins)
