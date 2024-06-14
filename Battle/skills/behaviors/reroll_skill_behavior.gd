extends SkillBehavior
## Comportamiento que vuelve a tirar cierta cantidad de las monedas usadas para
## pagar el coste de la habilidad
class_name RerollSkillBehavior

## Cantidad de monedas a volver a tirar
@export var rerolls: int = 0
## Selecciona si va a hacer una tirada normal o va a forzar cara o cruz.
@export var facing: Coin.Facing = Coin.Facing.ANY

func use(user, _target, coins):
	if not user is Player:
		return
	var iter = 0
	# Realiza un número de iteraciones igual al máximo entre rerolls 
	# y el número de monedas que se le ha pasado a la habilidad
	while iter < rerolls and iter < coins.size():
		# Selecciona una moneda y la marca disponible
		var coin = coins[iter]
		coin.set_available()
		# Tira la moneda si no se indica cara o cruz, si no se lo asigna
		if facing == Coin.Facing.ANY:
			user.flip(coin)
		else:
			coin.heads = true if facing == Coin.Facing.HEADS else false
		iter += 1
	_finish()

func get_description(_stats: CombatantStats = null) -> String:
	var description: String = ""
	var facing_text: String = "(%s)" % Coin.get_facing_text(facing)
	if rerolls > 0:
		var plural = "" if rerolls == 1 else "s"
		if description != "": description += "\n"
		description += "%d Reroll%s %s" % [rerolls, plural, facing_text]
	return description
