extends CoinSkill
class_name AttackSkill

func _init(p_data: AttackSkillData, p_user, p_target, p_coins):
	super._init(p_data,p_user,p_target,p_coins)

# Posiblemente dividir en distintas clases
func use():
	# Daño
	for i in range(data.hits):
		# TEMPORAL. Cambiar herencia de Skill a Node2D o Control? Crear objeto para cada golpe?
		print("HIT! "+str(data.damage)+" Damage")
		target.stats.take_damage(data.damage)
	super.use()
	# Regeneración de monedas:
	# Tiradas extra
#	var iter = 0
#	while iter < data.rerolls and iter < coins.size():
#		var coin = coins[iter]
#		coin.set_available()
#		# Tira la moneda si no se indica cara o cruz, si no se lo asigna.
#		if data.facing == 0:
#			coin.flip(user.stats.base_luck)
#		else:
#			coin.heads = true if data.facing == 1 else false
#		iter += 1
#	# Monedas efímeras
#	for i in range(data.ephemeral_coins):
#		var eph_coin = coins.front().get_ephemeral_copy()
#		if data.facing == 0:
#			user.flip(eph_coin)
#		else:
#			eph_coin.heads = true if data.facing == 1 else false
#		user.add_coin(eph_coin)
#
